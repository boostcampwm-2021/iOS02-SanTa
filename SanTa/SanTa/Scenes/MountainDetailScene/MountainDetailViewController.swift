//
//  MountainDetailViewController.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/08.
//

import UIKit
import MapKit

final class MountainDetailViewController: UIViewController {
    weak var coordinator: MountainDetailViewCoordinator?
    private var viewModel: MountainDetailViewModel?

    private lazy var backButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(.init(systemName: "xmark"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 25), forImageIn: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = "닫기"
        button.accessibilityHint = "목록 화면으로 돌아가시려면 이중 탭 하십시오"
        return button
    }()

    convenience init(viewModel: MountainDetailViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewModel()
    }
    
    deinit {
        coordinator?.viewControllerDidDeinit()
    }

    private func configureViewModel() {
        self.viewModel?.mountainInfoReceived = { [weak self] mountainDetail in
            self?.layoutMountainDetailView(mountainDetail: mountainDetail)
        }
        self.viewModel?.setUpViewModel()
    }
}

extension MountainDetailViewController {
    private func layoutMountainDetailView(mountainDetail: MountainDetailModel) {
        let headerView = UIView()
        let mapSnapShot = upperMapView(mountainDetail: mountainDetail)
        let titleView = lowerMountainTitleView(mountainDetail: mountainDetail)
        let tableView = configuredTableView(mountainDetail: mountainDetail)

        headerView.translatesAutoresizingMaskIntoConstraints = false
        mapSnapShot.translatesAutoresizingMaskIntoConstraints = false
        titleView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(mapSnapShot)
        headerView.addSubview(titleView)
        self.view.addSubview(tableView)
        self.view.addSubview(headerView)
        self.view.addSubview(self.backButton)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            headerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            headerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5)
        ])

        NSLayoutConstraint.activate([
            mapSnapShot.topAnchor.constraint(equalTo: headerView.topAnchor),
            mapSnapShot.leftAnchor.constraint(equalTo: headerView.leftAnchor),
            mapSnapShot.rightAnchor.constraint(equalTo: headerView.rightAnchor),
            mapSnapShot.heightAnchor.constraint(equalTo: headerView.heightAnchor, multiplier: 0.85)
        ])

        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: mapSnapShot.bottomAnchor),
            titleView.leftAnchor.constraint(equalTo: headerView.leftAnchor),
            titleView.rightAnchor.constraint(equalTo: headerView.rightAnchor),
            titleView.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.07)
        ])

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10)
        ])
    }

    @objc private func dismissViewController() {
        self.coordinator?.dismiss()
    }

    private func configuredTableView(mountainDetail: MountainDetailModel) -> UITableView {
        let tableView = UITableView()

        tableView.register(MountainDetailTableViewCell.self, forCellReuseIdentifier: MountainDetailTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }

    private func upperMapView(mountainDetail: MountainDetailModel) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = self
        mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: mountainDetail.latitude, longitude: mountainDetail.longitude), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))

        mapView.mapType = .satellite
        mapView.isUserInteractionEnabled = false
        let annotation = MountainAnnotation(title: mountainDetail.moutainName, subtitle: mountainDetail.altitude, latitude: mountainDetail.latitude, longitude: mountainDetail.longitude)
        mapView.register(MountainAnnotationView.self, forAnnotationViewWithReuseIdentifier: MountainAnnotationView.ReuseID)
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
        mapView.accessibilityElementsHidden = true

        return mapView
    }

    private func upperMapHeaderView(mountainDetail: MountainDetailModel) -> UIImageView {
        let mapOptions = MKMapSnapshotter.Options.init()
        mapOptions.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: mountainDetail.latitude, longitude: mountainDetail.longitude), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        mapOptions.mapType = .satellite

        let imgView = UIImageView()
        let snapShotter = MKMapSnapshotter(options: mapOptions)
        snapShotter.start { snapShot, error in
            if let snapShot = snapShot {
                let mapImage = snapShot.image
                UIGraphicsBeginImageContext(CGSize(width: 20, height: 20))
                UIImage(named: "SantaImage")?.draw(in: CGRect(x: 0, y: 0, width: 20, height: 20))
                let markerImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()

                UIGraphicsBeginImageContext(mapImage.size)
                mapImage.draw(in: CGRect(origin: CGPoint.zero, size: mapImage.size))
                markerImage?.draw(at: snapShot.point(for: CLLocationCoordinate2D(latitude: mountainDetail.latitude, longitude: mountainDetail.longitude)))
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()

                imgView.image = image

                print(snapShot.image.size, snapShot.point(for: CLLocationCoordinate2D(latitude: mountainDetail.latitude, longitude: mountainDetail.longitude)))
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        return imgView
    }

    private func lowerMountainTitleView(mountainDetail: MountainDetailModel) -> UIView {
        let titleView = MountainDetailTitleView()
        titleView.configure(with: mountainDetail.moutainName, distance: mountainDetail.distance)
        titleView.backgroundColor = .systemBackground
        return titleView
    }
}

extension MountainDetailViewController: UITableViewDelegate, UITableViewDataSource {
    enum MountainDetailCategories: Int, CaseIterable {
        case region = 0
        case altitude = 1
        case description = 2

        var text: String {
            switch self {
            case .region:
                return "소재지"
            case .altitude:
                return "고도"
            case .description:
                return "설명"
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MountainDetailTableViewCell.identifier, for: indexPath) as? MountainDetailTableViewCell,
              let category = MountainDetailCategories(rawValue: indexPath.row) else {
            return UITableViewCell()
        }

        var content: String? = ""
        switch category {
        case .region:
            content = self.viewModel?.mountainDetail?.regions.joined(separator: "\n")
        case .altitude:
            content = self.viewModel?.mountainDetail?.altitude
        case .description:
            content = self.viewModel?.mountainDetail?.mountainDescription
        }

        cell.configure(category: category.text, content: content ?? "")
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MountainDetailCategories.allCases.count
    }
}

extension MountainDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MountainAnnotation else { return nil }
        return MountainnDetailAnnotationView(
            annotation: annotation,
            reuseIdentifier: MountainnDetailAnnotationView.ReuseID
        )
    }
}
