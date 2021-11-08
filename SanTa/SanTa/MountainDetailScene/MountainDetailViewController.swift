//
//  MountainDetailViewController.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/08.
//

import UIKit
import MapKit

class MountainDetailViewController: UIViewController {
//    weak var mountainDetailViewCoordinator: MountainDetailViewCoordinator?
    private var viewModel: MountainDetailViewModel?
    
    convenience init(viewModel: MountainDetailViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let mapSnapShot = upperMapHeaderView(mountainDetail: mountainDetail)
        let titleView = lowerMountainTitleView(mountainDetail: mountainDetail)
        let tableView = configuredTableView(mountainDetail: mountainDetail)
        
        let mapConstraints = [
            mapSnapShot.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            mapSnapShot.topAnchor.constraint(equalTo: view.topAnchor),
            mapSnapShot.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapSnapShot.rightAnchor.constraint(equalTo: view.rightAnchor)
            
        ]
        NSLayoutConstraint.activate(mapConstraints)
        
        let titleViewConstraints = [
            titleView.topAnchor.constraint(equalTo: mapSnapShot.bottomAnchor),
            titleView.leftAnchor.constraint(equalTo: view.leftAnchor),
            titleView.rightAnchor.constraint(equalTo: view.rightAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 100)
        ]
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
        return UITableView()
    }
    
    private func upperMapHeaderView(mountainDetail: MountainDetailModel) -> UIImageView {
//        let mapOptions = MKMapSnapshotter.Options.init()
//        mapOptions.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: mountainDetail.latitude, longitude: mountainDetail.longitude), span: MKCoordinateSpan())
//        mapOptions.size = CGSize(width: view.bounds.width, height: view.bounds.height / 3)
//        mapOptions.mapType = .satellite
//        let mountainAnnotationView = MountainAnnotationView(annotation: MountainAnnotation(title: mountainDetail.moutainName, subtitle: mountainDetail.altitude, latitude: mountainDetail.latitude, longitude: mountainDetail.longitude, mountainDescription: mountainDetail.mountainDescription, region: mountainDetail.regions.join), reuseIdentifier: MountainAnnotationView.ReuseID)
//        mountainAnnotationView.canShowCallout = true
//        mountainAnnotationView.calloutOffset = CGPoint(x: 0, y: 5)
        let imgVIew = UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height / 3))
        imgVIew.backgroundColor = .yellow
        return imgVIew
    }
    
    private func lowerMountainTitleView(mountainDetail: MountainDetailModel) -> UIView {
        let empty = UIView()
        empty.backgroundColor = .blue
        return empty
    }
}
