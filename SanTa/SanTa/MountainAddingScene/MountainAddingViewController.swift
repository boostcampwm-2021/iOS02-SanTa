//
//  MountainAddingViewController.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/17.
//

import MapKit
import Combine

final class MountainAddingViewController: UIViewController {
    weak var coordinator: MountainAddingViewCoordinator?
    private var viewModel: MountainAddingViewModel?
    private var observers: [AnyCancellable] = []

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 2/5))
        mapView.delegate = self
        mapView.mapType = .mutedStandard
        mapView.isUserInteractionEnabled = false
        mapView.accessibilityElementsHidden = true
        return mapView
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(.init(systemName: "xmark"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 25), forImageIn: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = "닫기"
        button.accessibilityHint = "장소등록을 종료하려면 이중 탭 하십시오"
        return button
    }()

    private lazy var mountainAddingView: MountainAddingView = {
        let view = MountainAddingView()
        view.configure()
        return view
    }()

    convenience init(viewModel: MountainAddingViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mountainAddingView.newPlaceDelegate = self
        self.configureViews()
        self.configureViewModel()
    }

    private func configureViews() {
        self.view.addSubview(mapView)
        self.view.addSubview(backButton)
        self.view.addSubview(mountainAddingView)
        NSLayoutConstraint.activate([
            self.backButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.backButton.widthAnchor.constraint(equalToConstant: 30),
            self.backButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        NSLayoutConstraint.activate([
            self.mountainAddingView.topAnchor.constraint(equalTo: self.mapView.bottomAnchor),
            self.mountainAddingView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.mountainAddingView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.mountainAddingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

    private func configureViewModel() {
        self.viewModel?.$coordinate
            .sink(receiveValue: { [weak self] coordinate in
                self?.mapView.showsUserLocation = false
                self?.configureLocation(coordinate)
                self?.configureAnnotation(coordinate)
            })
            .store(in: &observers)
        self.viewModel?.addMountainResult
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                self?.showResult(result)
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "save"), object: nil)
            })
            .store(in: &observers)
        self.mapView.showsUserLocation = true
    }

    private func configureLocation(_ coordinate: CLLocationCoordinate2D?) {
        guard let coordinate = coordinate else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.mapView.setRegion(region, animated: false)
    }

    private func configureAnnotation(_ coordinate: CLLocationCoordinate2D?) {
        guard let coordinate = coordinate else { return }
        let mountainAnnotation = MountainAnnotation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.mapView.addAnnotation(mountainAnnotation)
    }

    private func showResult(_ result: MountainAddingViewModel.AddMountainResult) {
        let alert = UIAlertController(title: "산 추가하기", message: result.rawValue, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.dismissViewController()
        }
        alert.addAction(confirm)
        self.present(alert, animated: true)
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
        self.viewModel?.updateUserLocation(coordinate: userLocation.coordinate, altitude: userLocation.location?.altitude)
    }
}

extension MountainAddingViewController: NewPlaceAddable {
    func userDidTypeWrong() {
        let alert = UIAlertController(title: "올바르지 않은 입력", message: "산 이름과 설명이 입력되지 않았습니다", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        self.present(alert, animated: true)
    }

    func newPlaceShouldAdd(title: String, description: String) {
        self.viewModel?.addMountain(title: title, description: description)
    }
}
