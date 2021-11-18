//
//  ViewController.swift
//  SwipeView
//
//  Created by Jiwon Yoon on 2021/11/10.
//

import UIKit
import MapKit

class ResultDetailViewController: UIViewController {
    weak var coordinator: ResultDetailCoordinator?
    private var viewModel: ResultDetailViewModel?
    private var mapView: MKMapView?
    private var infoView: UIView?
    
    convenience init(viewModel: ResultDetailViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel?.resultDetailDataReceived = { detailData in
            self.layoutInitialRecordDetailView()
            self.registerRecognizers()
        }
        viewModel?.setUp()
    }
}

extension ResultDetailViewController {
    private func registerRecognizers() {
        let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(showSmallInfoView))
        swipeDownRecognizer.direction = .down
        self.infoView?.addGestureRecognizer(swipeDownRecognizer)
        
        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(showLargeInfoView))
        swipeUpRecognizer.direction = .up
        self.infoView?.addGestureRecognizer(swipeUpRecognizer)
    }
    
    private func layoutInitialRecordDetailView() {
        let mapFrame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height * 0.75)
        self.mapView = MKMapView(frame: mapFrame)
        if let mapView = self.mapView { self.view.addSubview(mapView) }
        
        self.infoView = UIView(frame: CGRect(x: 0, y: self.view.bounds.height * 0.75, width: self.view.bounds.width, height: self.view.bounds.height * 0.25))
        if let infoView = self.infoView {
            self.view.addSubview(infoView)
            infoView.addSubview(ResultDetailSmallerInfoView(frame: infoView.bounds))
        }
    }
}

extension ResultDetailViewController {
    @objc private func showLargeInfoView() {
        self.infoView?.subviews.forEach { $0.removeFromSuperview() }
        let newY = self.view.bounds.height * 0.1
        let newHeight = self.view.bounds.height * 0.9
        self.mapView?.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25) {
            self.infoView?.frame = CGRect(x: 0, y: newY, width: self.view.bounds.width, height: newHeight)
        }
        self.infoView?.addSubview(ResultDetailLargerInfoView(frame: self.infoView?.bounds ?? CGRect.zero))
    }
    
    @objc private func showSmallInfoView() {
        self.infoView?.subviews.forEach { $0.removeFromSuperview() }
        let newY = self.view.bounds.height * 0.75
        let newHeight = self.view.bounds.height * 0.25
        self.mapView?.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.25) {
            self.infoView?.frame = CGRect(x: 0, y: newY, width: self.view.bounds.width, height: newHeight)
        }
        self.infoView?.addSubview(ResultDetailSmallerInfoView(frame: self.infoView?.bounds ?? CGRect.zero))
    }
}


