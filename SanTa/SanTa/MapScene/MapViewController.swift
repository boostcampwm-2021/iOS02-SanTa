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
    private var startButton = UIButton()
    private var manager = CLLocationManager()
    private var userTrackingButton = MKUserTrackingButton()
    
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
        self.mapView.delegate = self
        self.view.addSubview(self.mapView)
        self.mapView.showsUserLocation = true
        self.mapView.showsScale = true
        self.mapView.showsCompass = true
        self.mapView.delegate = self
        
        self.view.addSubview(self.startButton)
        self.startButton.backgroundColor = .blue
        self.startButton.translatesAutoresizingMaskIntoConstraints = false
        self.startButton.setTitle("시작", for: .normal)
        self.startButton.setTitleColor(.white, for: .normal)
        self.startButton.titleLabel?.font = .boldSystemFont(ofSize: 25)
        self.startButton.layer.cornerRadius = 50
        self.startButton.layer.shadowColor = UIColor.gray.cgColor
        self.startButton.layer.shadowOpacity = 1
        self.startButton.layer.shadowRadius = 3
        self.startButton.layer.shadowOffset = CGSize(width: 0, height: 3)
    
        let startButtonConstraints = [
            self.startButton.widthAnchor.constraint(equalToConstant: 100),
            self.startButton.heightAnchor.constraint(equalToConstant: 100),
            self.startButton.bottomAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: -150),
            self.startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(startButtonConstraints)
        
        self.startButton.addTarget(self, action: #selector(presentRecordingViewController), for: .touchUpInside)
        
        self.userTrackingButton = .init(mapView: mapView)
        self.view.addSubview(self.userTrackingButton)
        self.userTrackingButton.isHidden = true
        self.userTrackingButton.backgroundColor = .white
        self.userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        self.userTrackingButton.layer.cornerRadius = 10
        self.userTrackingButton.clipsToBounds = true
        let userTrackingButtonConstraints = [
            self.userTrackingButton.widthAnchor.constraint(equalToConstant: 50),
            self.userTrackingButton.heightAnchor.constraint(equalToConstant: 50),
            self.userTrackingButton.leftAnchor.constraint(
                equalTo: self.mapView.rightAnchor,
                constant: -100
            ),
            self.userTrackingButton.centerYAnchor.constraint(equalTo: self.startButton.centerYAnchor)
        ]
        NSLayoutConstraint.activate(userTrackingButtonConstraints)
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
        self.manager.requestWhenInUseAuthorization()
        self.manager.requestAlwaysAuthorization()
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.startUpdatingLocation()
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
        for _ in 0..<200 {
            let latitude = Double.random(in: 36.0..<37.0)
            let longitude = -Double.random(in: 121.0..<122.0)
            let mountainAnnotaion = MountainAnnotaion()
            mountainAnnotaion.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.mapView.addAnnotation(mountainAnnotaion)
        }
    }
    
    @objc private func presentRecordingViewController() {
        coordinator?.presentRecordingViewController()
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let _ = annotation as? MountainAnnotaion {
            return MountainAnnotationView(
                annotation: annotation,
                reuseIdentifier: MountainAnnotationView.ReuseID
            )
        }
        return nil
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            self.render(location)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse ||
           manager.authorizationStatus == .authorizedAlways {
            userTrackingButton.isHidden = false
        }
    }
}

class MountainAnnotaion: NSObject, MKAnnotation {
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
}
