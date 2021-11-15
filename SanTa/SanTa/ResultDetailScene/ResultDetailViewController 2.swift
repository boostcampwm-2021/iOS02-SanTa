//
//  ResultDetailViewController.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/10.
//

/*
 func addPolylineToMap(locations: [CLLocation]) {
     let coordinates = locations.map { $0.coordinate }
     let geodesic = MKGeodesicPolyline(coordinates: coordinates, count: coordinates.count)
     mapView.add(geodesic)
 }
 */

import UIKit
import MapKit

class ResultDetailViewController: UIViewController {

    private let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension ResultDetailViewController {
    private func layoutResultDetailView() {
        self.view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        let mapViewConstraints = [
            mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            mapView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.65)
        ]
        NSLayoutConstraint.activate(mapViewConstraints)
    }
}
