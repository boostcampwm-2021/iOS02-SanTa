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
    
    private var smallerInformationView: ResultDetailSmallerInfoView = {
        let view = ResultDetailSmallerInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var largerInformationView: ResultDetailLargerInfoView = {
        let view = ResultDetailLargerInfoView()
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
            self?.smallerInformationView.configureLayout(
                distance: viewModel.distanceViewModel.totalDistance,
                time: viewModel.timeViewModel.totalTimeSpent,
                steps: viewModel.distanceViewModel.steps,
                maxAltitude: viewModel.altitudeViewModel.highest,
                minAltitude: viewModel.altitudeViewModel.lowest,
                averageSpeed: viewModel.averageSpeed()
            )
            self?.largerInformationView.configure()
            self?.configureViews()
            self?.configurePanGesture()
        }
        viewModel?.setUp()
    }
    
    private func configureSmallerView() {
        self.smallerInformationView = ResultDetailSmallerInfoView(frame: self.smallerInformationView.bounds)
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
        self.view.addSubview(self.largerInformationView)
        self.view.addSubview(self.smallerInformationView)
        
        NSLayoutConstraint.activate([
            self.mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.mapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant:  -(self.smallerInformationView.compositionalStackView.frame.height + tabBar.frame.height))
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
            self.smallerInformationView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.smallerInformationView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.smallerInformationView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.largerInformationView.topAnchor.constraint(equalTo: self.smallerInformationView.topAnchor),
            self.largerInformationView.leadingAnchor.constraint(equalTo: self.smallerInformationView.leadingAnchor),
            self.largerInformationView.trailingAnchor.constraint(equalTo: self.smallerInformationView.trailingAnchor),
            self.largerInformationView.bottomAnchor.constraint(equalTo: self.smallerInformationView.bottomAnchor)
        ])
        
        infoViewTopConstraint =
            self.smallerInformationView.topAnchor.constraint(equalTo: self.mapView.bottomAnchor)
        guard let infoViewConstraint = infoViewTopConstraint else { return }
        NSLayoutConstraint.activate([infoViewConstraint])
        
        self.view.layoutIfNeeded()
        self.infoViewHight = self.smallerInformationView.frame.height
    }
    
    private func findInfoViewBottomConstraints(traslation: CGFloat) {
        var bottomConstraint: NSLayoutConstraint?
        self.smallerInformationView.constraints.forEach {
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
        let translation = panGestureRecognizer.translation(in: self.smallerInformationView)
        let informationViewHeight = self.smallerInformationView.frame.height
        
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
            self.smallerInformationView.layer.cornerRadius = 13
            self.largerInformationView.layer.cornerRadius = 13
            self.changeInfoViewTopConstraints(traslation: translation.y + offset)

        case .ended:
            if self.smallerInformationView.frame.minY <= self.view.frame.height/2 {
                self.smallerInformationView.alpha = 0
                self.changeInfoViewTopConstraints(traslation: self.backButton.frame.maxY - self.mapView.safeAreaLayoutGuide.layoutFrame.maxY)
                self.isLargeInfoView = true
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.mapView.alpha = 1
                })
                self.smallerInformationView.layer.cornerRadius = 0
                self.largerInformationView.layer.cornerRadius = 0
                self.isLargeInfoView = false
                self.smallerInformationView.alpha = 1
                self.changeInfoViewTopConstraints(traslation: 0)
            }
            
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
                self.largerInformationView.collectionView.setNeedsLayout()
            }, completion: nil)
            
        default:
            break
        }
    }
}

extension ResultDetailViewController {
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


