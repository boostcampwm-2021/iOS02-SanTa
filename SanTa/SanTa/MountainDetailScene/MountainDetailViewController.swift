//
//  MountainDetailViewController.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/08.
//

import UIKit
import MapKit

class MountainDetailViewController: UIViewController {
    weak var coordinator: MountainDetailViewCoordinator?
    private var viewModel: MountainDetailViewModel?
    private var mutatingTopConstraint: NSLayoutConstraint?
    private var mutatingBottomConstraint: NSLayoutConstraint?
    private let maxRollUpDistance: CGFloat = 100
    
    convenience init(viewModel: MountainDetailViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewModel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.coordinator?.dismiss()
    }
    
    private func configureViewModel() {
        self.viewModel?.mountainInfoReceived = { mountainDetail in
            self.layoutMountainDetailView(mountainDetail: mountainDetail)
        }
        viewModel?.setUpViewModel()
    }
}

extension MountainDetailViewController {
    private func layoutMountainDetailView(mountainDetail: MountainDetailModel) {
        let headerView = UIView()
        let mapSnapShot = upperMapHeaderView(mountainDetail: mountainDetail)
        let titleView = lowerMountainTitleView(mountainDetail: mountainDetail)
        let tableView = configuredTableView(mountainDetail: mountainDetail)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        mapSnapShot.translatesAutoresizingMaskIntoConstraints = false
        titleView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        headerView.addSubview(mapSnapShot)
        headerView.addSubview(titleView)
        view.addSubview(tableView)
        view.addSubview(headerView)
        
        let headerConstraints = [
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ]
        NSLayoutConstraint.activate(headerConstraints)
        
        let mapConstraints = [
            mapSnapShot.topAnchor.constraint(equalTo: headerView.topAnchor),
            mapSnapShot.leftAnchor.constraint(equalTo: headerView.leftAnchor),
            mapSnapShot.rightAnchor.constraint(equalTo: headerView.rightAnchor),
            mapSnapShot.heightAnchor.constraint(equalTo: headerView.heightAnchor, multiplier: 0.85)
            
        ]
        NSLayoutConstraint.activate(mapConstraints)
        
        self.mutatingTopConstraint = titleView.topAnchor.constraint(equalTo: mapSnapShot.bottomAnchor)
        self.mutatingBottomConstraint = titleView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        var titleViewConstraints = [
            titleView.leftAnchor.constraint(equalTo: headerView.leftAnchor),
            titleView.rightAnchor.constraint(equalTo: headerView.rightAnchor),
        ]
        
        if let upperConstraint = self.mutatingTopConstraint,
           let lowerConstraint = self.mutatingBottomConstraint {
            titleViewConstraints.append(upperConstraint)
            titleViewConstraints.append(lowerConstraint)
        }
        
        NSLayoutConstraint.activate(titleViewConstraints)
        
        let tableViewConstraints = [
            tableView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]
        NSLayoutConstraint.activate(tableViewConstraints)
    }
    
    private func configuredTableView(mountainDetail: MountainDetailModel) -> UITableView {
        let tableView = UITableView()
        
        tableView.register(MountainDetailTableViewCell.self, forCellReuseIdentifier: MountainDetailTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
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
                
                UIGraphicsBeginImageContext(mapImage.size)
                mapImage.draw(in: CGRect(origin: CGPoint.zero, size: mapImage.size))
                UIImage(systemName: "heart.fill")?.draw(at: snapShot.point(for: CLLocationCoordinate2D(latitude: mountainDetail.latitude, longitude: mountainDetail.longitude)))
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
        titleView.backgroundColor = .white
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

extension MountainDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let remainingScroll = scrollView.contentSize.height - scrollView.bounds.size.height
        let rollUp = min(remainingScroll, self.maxRollUpDistance)
        if scrollView.contentOffset.y < rollUp && scrollView.contentOffset.y > 0 {
            self.mutatingTopConstraint?.constant = -scrollView.contentOffset.y
            self.mutatingBottomConstraint?.constant = -scrollView.contentOffset.y
        }
    }
}
