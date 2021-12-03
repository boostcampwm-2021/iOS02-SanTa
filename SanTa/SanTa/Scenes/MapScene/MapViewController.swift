//
//  MapViewController.swift
//  SanTa
//
//  Created by shin jae ung on 2021/10/28.
//
import MapKit
import Combine

protocol Animatable: AnyObject {
    func shouldAnimate()
    func shouldStopAnimate()
}

final class MapViewController: UIViewController {
    weak var coordinator: MapViewCoordinator?
    private var viewModel: MapViewModel?
    private var observers: [AnyCancellable] = []
    private let mapDictionary: [Map: MKMapType] = [.infomation: .mutedStandard, .normal: .standard, .satellite: .hybrid]

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView(frame: view.bounds)
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.delegate = self
        mapView.accessibilityElementsHidden = true
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
        button.addTarget(self, action: #selector(presentRecordingViewController), for: .touchDown)
        button.accessibilityHint = "측정을 시작하려면 이중 탭 하십시오"
        return button
    }()

    private lazy var newPlaceButton: UIButton = {
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
        button.addTarget(self, action: #selector(presentMountainAddingViewController), for: .touchUpInside)
        return button
    }()

    private lazy var userTrackingButton: MKUserTrackingButton = {
        let button = MKUserTrackingButton(mapView: self.mapView)
        button.isHidden = true
        button.tintColor = UIColor(named: "SantaColor")
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
        self.configureBindings()
        self.configureNotification()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.viewModel?.viewWillAppear()
    }

    private func configureViews() {
        self.view.addSubview(self.mapView)
        self.view.addSubview(self.startButton)
        self.view.addSubview(self.newPlaceButton)
        self.view.addSubview(self.userTrackingButton)

        NSLayoutConstraint.activate([
            self.startButton.widthAnchor.constraint(equalToConstant: 100),
            self.startButton.heightAnchor.constraint(equalToConstant: 100),
            self.startButton.bottomAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.bottomAnchor, constant: -mapView.frame.height/15),
            self.startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            self.userTrackingButton.widthAnchor.constraint(equalToConstant: 50),
            self.userTrackingButton.heightAnchor.constraint(equalToConstant: 50),
            self.userTrackingButton.leftAnchor.constraint(equalTo: mapView.rightAnchor, constant: -100),
            self.userTrackingButton.centerYAnchor.constraint(equalTo: self.startButton.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            self.newPlaceButton.widthAnchor.constraint(equalToConstant: 150),
            self.newPlaceButton.heightAnchor.constraint(equalToConstant: 30),
            self.newPlaceButton.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -10),
            self.newPlaceButton.centerXAnchor.constraint(equalTo: self.startButton.centerXAnchor)
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

    private func configureBindings() {
        self.viewModel?.configureBindings()
        self.viewModel?.$mountains
            .sink(receiveValue: { [weak self] mountains in
                self?.configureMarkers(mountains)
            })
            .store(in: &self.observers)
        self.viewModel?.$map
            .sink(receiveValue: { [weak self] map in
                self?.configureMap(map)
            })
            .store(in: &self.observers)
        self.viewModel?.$initialLocation
            .sink(receiveValue: { [weak self] location in
                self?.configureLocation(location)
            })
            .store(in: &self.observers)
        self.viewModel?.$locationPermission
            .sink(receiveValue: { [weak self] bool in
                self?.configureUserTrackingButton(bool)
            })
            .store(in: &self.observers)
    }

    private func configureNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(shouldUpdateMarkers), name: NSNotification.Name.init(rawValue: "save"), object: nil)
    }

    @objc func shouldUpdateMarkers() {
        self.viewModel?.updateMarker()
    }

    private func configureMarkers(_ mountains: [MountainEntity]?) {
        self.mapView.removeAnnotations(self.mapView.annotations)
        guard let mountains = mountains else { return }
        let annotations = mountains.map { mountainEntity in
            return MountainAnnotation(
                title: mountainEntity.mountain.mountainName,
                subtitle: mountainEntity.mountain.mountainHeight + "m",
                latitude: mountainEntity.latitude,
                longitude: mountainEntity.longitude,
                mountainDescription: mountainEntity.mountain.mountainShortDescription,
                region: mountainEntity.mountain.mountainRegion
            )
        }
        self.mapView.addAnnotations(annotations)
    }

    private func configureMap(_ map: Map?) {
        guard let map = map,
              let mapType = mapDictionary[map] else { return }
        self.mapView.mapType = mapType
    }

    private func configureLocation(_ location: CLLocation?) {
        guard let location = location else { return }
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

    private func configureUserTrackingButton(_ permission: Bool?) {
        guard let permission = permission else { return }
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
        if let viewModel = self.viewModel, viewModel.locationPermission == true {
            self.coordinator?.presentRecordingViewController()
        } else {
            self.present(authAlert(), animated: false)
        }
    }

    @objc private func presentMountainAddingViewController() {
        self.coordinator?.presentMountainAddingViewController()
    }
}

extension MapViewController: Animatable {
    func shouldAnimate() {
        let image = UIImage.gifImage(named: "walkingManAnimation", withTintColor: .white)
        self.startButton.setImage(image, for: .normal)
        self.startButton.accessibilityHint = "현재 측정 중입니다. 측정화면으로 돌아가려면 이중 탭 하십시오"
    }

    func shouldStopAnimate() {
        self.startButton.setImage(nil, for: .normal)
        self.startButton.accessibilityHint = "측정을 시작하려면 이중 탭 하십시오"
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
            if newPlaceButton.isHidden {
                self.newPlaceButton.isHidden = false
                self.newPlaceButton.alpha = 0
                UIView.transition(
                    with: newPlaceButton,
                    duration: 0.5,
                    options: [],
                    animations: { [weak self] in
                        self?.newPlaceButton.alpha = 1
                    }
                )
            }
        default:
            UIView.transition(
                with: newPlaceButton,
                duration: 0.5,
                options: [],
                animations: { [weak self] in
                    self?.newPlaceButton.alpha = 0
                }, completion: { [weak self] _ in
                    self?.newPlaceButton.isHidden = true
                }
            )
        }
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? MountainAnnotation else { return }
        coordinator?.presentMountainDetailViewController(mountainAnnotation: annotation)
    }
}

fileprivate extension UIImage {
    class func gifImage(named: String, withTintColor: UIColor? = nil) -> UIImage? {
        guard let bundleURL = Bundle.main.url(forResource: named, withExtension: "gif"),
              let imageData = try? Data(contentsOf: bundleURL),
              let source = CGImageSourceCreateWithData(imageData as CFData, nil)
        else { return nil }
        return UIImage.animatedImageWithSource(source, withTintColor: withTintColor)
    }

    private class func animatedImageWithSource(_ source: CGImageSource, withTintColor: UIColor?) -> UIImage? {
        let count: Int = CGImageSourceGetCount(source)
        let images: [UIImage] = (0..<count).compactMap {
            CGImageSourceCreateImageAtIndex(source, $0, nil)
        }.map {
            if let tintColor = withTintColor {
                return UIImage(cgImage: $0).withTintColor(tintColor)
            } else {
                return UIImage(cgImage: $0)
            }
        }
        let time: TimeInterval = 0.05 * Double(images.count)

        return UIImage.animatedImage(with: images, duration: time)
    }
}
