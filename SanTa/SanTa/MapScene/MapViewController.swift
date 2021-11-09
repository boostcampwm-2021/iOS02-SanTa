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
        switch self.manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            userTrackingButton.isHidden = false
        default:
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
                longitude: mountainEntity.longitude
            )
            mapView?.addAnnotation(mountainAnnotation)
        }
    }
    
    private func configureViews() {
        self.mapView = MKMapView(frame: view.bounds)
        guard let mapView = mapView else { return }
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
    
    private func authAlert() -> UIAlertController {
        let alert = UIAlertController(title: "위치정보 활성화", message: "지도에 현재 위치를 표시할 수 있도록 위치정보를 활성화해주세요", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "아니요", style: .cancel)
        let confirm = UIAlertAction(title: "활성화", style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        }
        alert.addAction(cancel)
        alert.addAction(confirm)
        return alert
    }

    @objc private func presentRecordingViewController() {
        switch self.manager.authorizationStatus{
        case .authorizedWhenInUse, .authorizedAlways:
            self.coordinator?.presentRecordingViewController()
        default:
            self.present(authAlert(), animated: false)
        }
    }
    
    func presentAnimation() {
        let image = UIImage.gifImage(named: "walkingManAnimation")
        self.startButton.setImage(image, for: .normal)
    }
    
    func unpresentAnimation(){
        self.startButton.setImage(nil, for: .normal)
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
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.manager.stopUpdatingLocation()
            self.render(location)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch self.manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            userTrackingButton.isHidden = false
        default:
            userTrackingButton.isHidden = true
        }
    }
}
