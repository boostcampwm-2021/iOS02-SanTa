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
    private var viewModel: MapViewModel?
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView(frame: view.bounds)
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.delegate = self
        return mapView
    }()
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "SantaColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("시작", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 25)
        button.layer.cornerRadius = 50
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 3
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        return button
    }()
    private lazy var addAnnotationButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "SantaColor")
        button.setTitle("이곳을 알고 계시나요?", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 15
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 3
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        return button
    }()
    private lazy var userTrackingButton: MKUserTrackingButton = {
        let button = MKUserTrackingButton(mapView: self.mapView)
        button.isHidden = true
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    convenience init(viewModel: MapViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViews()
        self.registerAnnotationView()
        self.configureViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.viewWillAppear()
        self.configureUserTrackingButton()
    }
    
    private func configureViews() {
        self.view.addSubview(self.mapView)
        self.view.addSubview(self.startButton)
        self.view.addSubview(self.addAnnotationButton)
        self.view.addSubview(self.userTrackingButton)
        self.startButton.addTarget(self, action: #selector(presentRecordingViewController), for: .touchDown)
        
        NSLayoutConstraint.activate([
            self.startButton.widthAnchor.constraint(equalToConstant: 100),
            self.startButton.heightAnchor.constraint(equalToConstant: 100),
            self.startButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -mapView.frame.height/6),
            self.startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            self.userTrackingButton.widthAnchor.constraint(equalToConstant: 50),
            self.userTrackingButton.heightAnchor.constraint(equalToConstant: 50),
            self.userTrackingButton.leftAnchor.constraint(equalTo: mapView.rightAnchor, constant: -100),
            self.userTrackingButton.centerYAnchor.constraint(equalTo: self.startButton.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            self.addAnnotationButton.widthAnchor.constraint(equalToConstant: 150),
            self.addAnnotationButton.heightAnchor.constraint(equalToConstant: 30),
            self.addAnnotationButton.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -10),
            self.addAnnotationButton.centerXAnchor.constraint(equalTo: self.startButton.centerXAnchor)
        ])
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
    
    private func configureViewModel() {
        self.viewModel?.markersShouldUpdate = { self.configureMarkers() }
        self.viewModel?.mapShouldUpdate = { self.configureMap() }
        self.viewModel?.initialLocationShouldUpdate = { self.configureLocation() }
        self.viewModel?.locationPermissionDidChange = { self.configureUserTrackingButton() }
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
            self.mapView.addAnnotation(mountainAnnotation)
        }
    }
    
    private func configureMap() {
        guard let map = viewModel?.map else { return }
        switch map {
        case .infomation:
            self.mapView.mapType = .mutedStandard
        case .normal:
            self.mapView.mapType = .standard
        case .satellite:
            self.mapView.mapType = .hybrid
        }
    }
    
    private func configureLocation() {
        guard let location = viewModel?.initialLocation else { return }
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
    
    private func configureUserTrackingButton() {
        guard let permission = viewModel?.locationPermission else { return }
        self.userTrackingButton.isHidden = !permission
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
        if let viewModel = self.viewModel, viewModel.locationPermission {
            self.coordinator?.presentRecordingViewController()
        } else {
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
        coordinator?.presentMountainDetailViewController(mountainAnnotation: annotation)
    }
}
