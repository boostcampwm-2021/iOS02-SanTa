//
//  ViewController.swift
//  SwipeView
//
//  Created by Jiwon Yoon on 2021/11/10.
//

import UIKit
import MapKit

class ResultDetailViewController: UIViewController {
    
    weak var coordinator: ResultDetailViewCoordinator?
    
    private var viewModel: ResultDetailViewModel?
    
    private var infoViewTopConstraint: NSLayoutConstraint?
    private var infoViewHight: CGFloat?
    private var isLargeInfoView = false
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = .mutedStandard
        mapView.backgroundColor = .black
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private var informationView: ResultDetailSmallerInfoView = {
        let view = ResultDetailSmallerInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var backButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "chevron.backward"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 25), forImageIn: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        return button
    }()
    
    private var changeButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "ellipsis.circle"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 25), forImageIn: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(presentModifyResultAlert), for: .touchUpInside)
        return button
    }()
    
    convenience init(viewModel: ResultDetailViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel?.recordDidFetch = { [weak self] in
            guard let viewModel = self?.viewModel else { return }
            self?.informationView.configureLayout(
                distance: viewModel.distanceViewModel.totalDistance,
                time: viewModel.timeViewModel.totalTimeSpent,
                steps: viewModel.distanceViewModel.steps,
                maxAltitude: viewModel.altitudeViewModel.highest,
                minAltitude: viewModel.altitudeViewModel.lowest,
                averageSpeed: viewModel.averageSpeed()
            )
            self?.configureViews()
            self?.configurePanGesture()
        }
        viewModel?.setUp()
    }
    
    private func configureSmallerView() {
        self.informationView = ResultDetailSmallerInfoView(frame: self.informationView.bounds)
    }
    
    private func configurePanGesture() {
        let informationViewPan = UIPanGestureRecognizer(target: self, action: #selector(informationViewPanPanned(_:)))
        
        informationViewPan.delaysTouchesBegan = false
        informationViewPan.delaysTouchesEnded = false
        view.addGestureRecognizer(informationViewPan)
    }
    
    private func configureViews() {
        guard let tabBar = self.navigationController?.tabBarController?.tabBar else { return }
        self.view.addSubview(self.mapView)
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.changeButton)
        self.view.addSubview(self.informationView)
        
        NSLayoutConstraint.activate([
            self.mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.mapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant:  -(self.informationView.compositionalStackView.frame.height + tabBar.frame.height))
        ])
        
        NSLayoutConstraint.activate([
            self.backButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.backButton.widthAnchor.constraint(equalToConstant: 40),
            self.backButton.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        NSLayoutConstraint.activate([
            self.changeButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            self.changeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.changeButton.widthAnchor.constraint(equalToConstant: 40),
            self.changeButton.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        NSLayoutConstraint.activate([
            self.informationView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.informationView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.informationView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        infoViewTopConstraint =
            self.informationView.topAnchor.constraint(equalTo: self.mapView.bottomAnchor)
        guard let infoViewConstraint = infoViewTopConstraint else { return }
        NSLayoutConstraint.activate([infoViewConstraint])
        
        self.view.layoutIfNeeded()
        self.infoViewHight = self.informationView.frame.height
    }
    
    private func findInfoViewBottomConstraints(traslation: CGFloat) {
        var bottomConstraint: NSLayoutConstraint?
        self.informationView.constraints.forEach {
            if $0.firstAttribute == .bottom {
                bottomConstraint = $0
            }
        }
        bottomConstraint?.constant = traslation
    }
    
    private func changeInfoViewTopConstraints(traslation: CGFloat) {
        guard let infoViewConstraint = self.infoViewTopConstraint else { return }
        infoViewConstraint.constant = traslation
    }
    
    @objc private func informationViewPanPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translation(in: self.informationView)
        let informationViewHeight = self.informationView.frame.height
        
        switch panGestureRecognizer.state {
        case .began:
            UIView.animate(withDuration: 0.2, animations: {
                self.mapView.alpha = 0.8
            })
            
        case .changed:
            var offset: CGFloat = 0
            if isLargeInfoView {
                offset = self.backButton.frame.maxY - self.mapView.safeAreaLayoutGuide.layoutFrame.maxY
            }
            
            guard (self.view.frame.height - informationViewHeight) >= (self.backButton.frame.height + 10),
                  let infoViewHight = self.infoViewHight,
                  infoViewHight < (informationViewHeight - (translation.y + offset)) else {
                return
            }
            
            changeInfoViewTopConstraints(traslation: translation.y + offset)

        case .ended:
            if self.informationView.frame.minY <= self.view.frame.height/2 {
                changeInfoViewTopConstraints(traslation: self.backButton.frame.maxY - self.mapView.safeAreaLayoutGuide.layoutFrame.maxY)
                isLargeInfoView = true
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.mapView.alpha = 1
                })
                isLargeInfoView = false
                changeInfoViewTopConstraints(traslation: 0)
            }
            
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
            
        default:
            break
        }
    }
}

extension ResultDetailViewController {
    @objc private func showLargeInfoView() {
        self.informationView.subviews.forEach { $0.removeFromSuperview() }
        let newY = self.view.bounds.height * 0.1
        let newHeight = self.view.bounds.height * 0.9
        self.mapView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25) {
            self.informationView.frame = CGRect(x: 0, y: newY, width: self.view.bounds.width, height: newHeight)
        }
    }
    
    @objc private func showSmallInfoView() {
        self.informationView.subviews.forEach { $0.removeFromSuperview() }
        let newY = self.view.bounds.height * 0.75
        let newHeight = self.view.bounds.height * 0.25
        self.mapView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.25) {
            self.informationView.frame = CGRect(x: 0, y: newY, width: self.view.bounds.width, height: newHeight)
        }
    }
    
    @objc func dismissViewController() {
        coordinator?.dismiss()
    }
    
    @objc func presentModifyResultAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let changeTitle = UIAlertAction(title: "제목 변경", style: .default) { action in
            
        }
        let delete = UIAlertAction(title: "삭제", style: .destructive) { action in
            
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(changeTitle)
        alert.addAction(delete)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}


