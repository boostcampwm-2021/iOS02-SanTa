//
//  MapViewController.swift
//  SanTa
//
//  Created by shin jae ung on 2021/10/28.
//
import MapKit

protocol Animatable: AnyObject {
    func shouldAnimate()
    func shouldStopAnimate()
}

class MapViewController: UIViewController {
    weak var coordinator: MapViewCoordinator?
    private var mapView: MKMapView?
    private var startButton = UIButton()
    private var addAnnotationButton = UIButton()
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
        viewModel?.viewWillAppear()
        switch self.manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            self.userTrackingButton.isHidden = false
        default:
            self.userTrackingButton.isHidden = true
        }
    }
    
    private func configureViewModel() {
        self.viewModel?.markersShouldUpdate = { self.configureMarkers() }
        self.viewModel?.mapShouldUpdate = { self.configureMap() }
        self.viewModel?.viewDidLoad()
    }
    
    private func configureMarkers() {
        self.viewModel?.mountains?.forEach{ mountainEntity in
            let mountainAnnotation = MountainAnnotation(
                title: mountainEntity.mountain.mountainName,
                subtitle: mountainEntity.mountain.mountainHeight + "m",
                latitude: mountainEntity.latitude,
                longitude: mountainEntity.longitude,
                mountainDescription: mountainEntity.mountain.mountainShortDescription,
                region: mountainEntity.mountain.mountainRegion
            )
            self.mapView?.addAnnotation(mountainAnnotation)
        }
    }
    
    private func configureMap() {
        guard let map = viewModel?.map else { return }
        switch map {
        case .infomation:
            mapView?.mapType = .mutedStandard
        case .normal:
            mapView?.mapType = .standard
        case .satellite:
            mapView?.mapType = .satellite
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
        self.startButton.backgroundColor = UIColor(named: "SantaColor")
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
        
        self.startButton.addTarget(self, action: #selector(presentRecordingViewController), for: .touchDown)
        
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
        
        self.view.addSubview(self.addAnnotationButton)
        self.addAnnotationButton.isHidden = true
        self.addAnnotationButton.translatesAutoresizingMaskIntoConstraints = false
        self.addAnnotationButton.backgroundColor = UIColor(named: "SantaColor")
        self.addAnnotationButton.setTitle("이곳을 알고 계시나요?", for: .normal)
        self.addAnnotationButton.setTitleColor(.white, for: .normal)
        self.addAnnotationButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        self.addAnnotationButton.layer.cornerRadius = 15
        self.addAnnotationButton.layer.shadowColor = UIColor.gray.cgColor
        self.addAnnotationButton.layer.shadowOpacity = 1
        self.addAnnotationButton.layer.shadowRadius = 3
        self.addAnnotationButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        let addAnnotationButtonConstraints = [
            self.addAnnotationButton.widthAnchor.constraint(equalToConstant: 150),
            self.addAnnotationButton.heightAnchor.constraint(equalToConstant: 30),
            self.addAnnotationButton.bottomAnchor.constraint(
                equalTo: startButton.topAnchor,
                constant: -10
            ),
            self.addAnnotationButton.centerXAnchor.constraint(equalTo: self.startButton.centerXAnchor)
        ]
        NSLayoutConstraint.activate(addAnnotationButtonConstraints)
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
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        switch self.manager.authorizationStatus{
        case .authorizedWhenInUse, .authorizedAlways:
            self.coordinator?.presentRecordingViewController()
        default:
            self.present(authAlert(), animated: false)
        }
    }
}

extension MapViewController: Animatable {
    func shouldAnimate() {
        let image = UIImage.gifImage(named: "walkingManAnimation", withTintColor: .white)
        self.startButton.setImage(image, for: .normal)
    }
    
    func shouldStopAnimate() {
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

    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        switch mode {
        case .follow, .followWithHeading:
            if addAnnotationButton.isHidden {
                self.addAnnotationButton.isHidden = false
                self.addAnnotationButton.alpha = 0
                UIView.transition(
                    with: addAnnotationButton,
                    duration: 0.5,
                    options: [],
                    animations: { [weak self] in
                        self?.addAnnotationButton.alpha = 1
                    }
                )
            }
        default:
            UIView.transition(
                with: addAnnotationButton,
                duration: 0.5,
                options: [],
                animations: { [weak self] in
                    self?.addAnnotationButton.alpha = 0
                }, completion: { [weak self] _ in
                    self?.addAnnotationButton.isHidden = true
                }
            )
        }
    }
  
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? MountainAnnotation else { return }
        
        coordinator?.presentMountainDetailViewController(mountainAnnotation: annotation, location: self.manager.location)
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
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            self.userTrackingButton.isHidden = false
        default:
            self.userTrackingButton.isHidden = true
        }
    }
}
