//
//  ResultDetailViewController.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/11.
//

import UIKit
import MapKit

class ResultDetailViewController: UIViewController {
    private let mapView = MKMapView()
    private let miniInfoView = ResultDetailSmallerInfoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layout()
        // Do any additional setup after loading the view.
    }
}

extension ResultDetailViewController {
    private func layout() {
        self.view.addSubview(self.mapView)
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        
        let mapViewConstraints = [
            mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            mapView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.75)
        ]
        NSLayoutConstraint.activate(mapViewConstraints)
        
        self.view.addSubview(self.miniInfoView)
        self.miniInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        let swipeViewConstraints = [
            miniInfoView.topAnchor.constraint(equalTo: self.mapView.bottomAnchor),
            miniInfoView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            miniInfoView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            miniInfoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ]
        miniInfoView.backgroundColor = .red
        NSLayoutConstraint.activate(swipeViewConstraints)
    }
    
}
