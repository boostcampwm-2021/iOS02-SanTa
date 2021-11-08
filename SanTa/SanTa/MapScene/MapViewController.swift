//
//  MapViewController.swift
//  SanTa
//
//  Created by shin jae ung on 2021/10/28.
//
import MapKit

class MapViewController: UIViewController {
    weak var coordinator: MapViewCoordinator?
    private var mapView: MKMapView?
    private var startButton = UIButton()
    private var manager = CLLocationManager()
    private var userTrackingButton = MKUserTrackingButton()
    private var viewModel: MapViewModel?
    
    convenience init(viewModel: MapViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViews()
        self.registerAnnotationView()
        self.configureCoreLocationManager()
        self.configureViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if manager.authorizationStatus == .authorizedAlways ||
            manager.authorizationStatus == .authorizedWhenInUse {
            userTrackingButton.isHidden = false
        } else {
            userTrackingButton.isHidden = true
        }
    }
    
    private func configureViewModel() {
        self.viewModel?.markersShouldUpdate = { self.configureMarkers() }
        self.viewModel?.viewDidLoad()
    }
    
    private func configureMarkers() {
        self.viewModel?.mountains?.forEach{ mountainEntity in
            let mountainAnnotation = MountainAnnotation(
                title: mountainEntity.mountain.mountainName,
                subtitle: mountainEntity.mountain.mountainHeight,
                latitude: mountainEntity.latitude,
                longitude: mountainEntity.longitude,
                mountainDescription: mountainEntity.mountain.mountainShortDescription,
                region: mountainEntity.mountain.mountainRegion
            )
            mapView?.addAnnotation(mountainAnnotation)
        }
    }
    
    private func configureViews() {
        self.mapView = MKMapView(frame: view.bounds)
        guard let mapView = mapView else { return }
        mapView.showsUserLocation = true
        mapView.delegate = self
        self.view.addSubview(mapView)
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.delegate = self
        
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
            self.startButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -150),
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
                equalTo: mapView.rightAnchor,
                constant: -100
            ),
            self.userTrackingButton.centerYAnchor.constraint(equalTo: self.startButton.centerYAnchor)
        ]
        NSLayoutConstraint.activate(userTrackingButtonConstraints)
    }
    
    private func registerAnnotationView() {
        guard let mapView = mapView else { return }
        mapView.register(
            MountainAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier
        )
        mapView.register(
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
        guard let mapView = mapView else { return }
        let coordinate = CLLocationCoordinate2D(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        let span = MKCoordinateSpan(
            latitudeDelta: 0.01,
            longitudeDelta: 0.01
        )
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }

    @objc private func presentRecordingViewController() {
        coordinator?.presentRecordingViewController()
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MountainAnnotation else { return nil }
        return MountainAnnotationView(
            annotation: annotation,
            reuseIdentifier: MountainAnnotationView.ReuseID
        )
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? MountainAnnotation else { return }
        
        
        
        //navigate using annotation
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
