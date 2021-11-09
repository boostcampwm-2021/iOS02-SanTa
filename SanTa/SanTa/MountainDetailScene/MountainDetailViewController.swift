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
        view.addSubview(headerView)
        view.addSubview(tableView)
        
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
        
        let titleViewConstraints = [
            titleView.topAnchor.constraint(equalTo: mapSnapShot.bottomAnchor),
            titleView.leftAnchor.constraint(equalTo: headerView.leftAnchor),
            titleView.rightAnchor.constraint(equalTo: headerView.rightAnchor),
            titleView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(titleViewConstraints)
        
        let tableViewConstraints = [
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]
        NSLayoutConstraint.activate(tableViewConstraints)
    }
    
    private func configuredTableView(mountainDetail: MountainDetailModel) -> UITableView {
        return UITableView()
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
        let empty = UIView()
        empty.backgroundColor = .blue
        return empty
    }
}
