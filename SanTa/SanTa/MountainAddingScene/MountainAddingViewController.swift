//
//  MountainAddingViewController.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/17.
//

import MapKit

class MountainAddingViewController: UIViewController {
    weak var coordinator: MountainAddingViewCoordinator?
    private var viewModel: MountainAddingViewModel?
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 2/5))
        mapView.delegate = self
        mapView.mapType = .mutedStandard
        mapView.isUserInteractionEnabled = false
        return mapView
    }()
    private lazy var backButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(.init(systemName: "xmark"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 25), forImageIn: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    convenience init(viewModel: MountainAddingViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViews()
        self.configureViewModel()
    }
    
    private func configureViews() {
        self.view.addSubview(mapView)
        self.view.addSubview(backButton)
        NSLayoutConstraint.activate([
            self.backButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.backButton.widthAnchor.constraint(equalToConstant: 30),
            self.backButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configureViewModel() {
        self.viewModel?.locationDidUpdate = { [weak self] in
            self?.mapView.showsUserLocation = false
            self?.configureLocation()
            self?.configureAnnotation()
        }
        mapView.showsUserLocation = true
    }
    
    private func configureLocation() {
        guard let userLocation = self.viewModel?.userLocation else { return }
        let location = CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(region, animated: false)
    }
    
    private func configureAnnotation() {
        guard let userLocation = self.viewModel?.userLocation else { return }
        let mountainAnnotation = MountainAnnotation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        self.mapView.addAnnotation(mountainAnnotation)
    }
    
    @objc func dismissViewController() {
        self.coordinator?.dismiss()
    }
}

extension MountainAddingViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MountainAnnotation else { return nil }
        return MountainAnnotationView(
            annotation: annotation,
            reuseIdentifier: MountainAnnotationView.ReuseID
        )
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.viewModel?.userLocation = (userLocation.coordinate.latitude, userLocation.coordinate.longitude)
    }
}

