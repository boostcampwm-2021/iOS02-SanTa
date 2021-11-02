//
//  MapViewController.swift
//  SanTa
//
//  Created by shin jae ung on 2021/10/28.
//
import MapKit

class MapViewController: UIViewController {
    weak var coordinator: MapViewCoordinator?
    private var mapView = MKMapView()
    private var manager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViews()
        self.registerAnnotationView()
        self.configureCoreLocationManager()
        self.testCoordinates()
    }
    
    private func configureViews() {
        self.mapView = MKMapView(frame: view.bounds)
        self.mapView.showsUserLocation = true
        self.view.addSubview(self.mapView)
    }
    
    private func registerAnnotationView() {
        self.mapView.register(
            MountainAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier
        )
        self.mapView.register(
            ClusterAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier
        )
    }
    
    private func configureCoreLocationManager() {
        self.manager = CLLocationManager()
        self.manager?.requestWhenInUseAuthorization()
        self.manager?.requestAlwaysAuthorization()
        self.manager?.delegate = self
        self.manager?.desiredAccuracy = kCLLocationAccuracyBest
        self.manager?.startUpdatingLocation()
    }
    
    private func render(_ location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        let span = MKCoordinateSpan(
            latitudeDelta: 0.01,
            longitudeDelta: 0.01
        )
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
    }
    
    private func testCoordinates() {
        for _ in 0...200 {
            let latitude = Double.random(in: 36.0..<37.0)
            let longitude = -Double.random(in: 121.0..<122.0)
            let pin = MKPointAnnotation()
            pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            mapView.addAnnotation(pin)
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return MountainAnnotationView(
            annotation: annotation,
            reuseIdentifier: MountainAnnotationView.ReuseID
        )
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            self.render(location)
        }
    }
}
