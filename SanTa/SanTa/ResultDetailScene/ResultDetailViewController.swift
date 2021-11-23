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
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = .mutedStandard
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
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: label.font.pointSize, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    convenience init(viewModel: ResultDetailViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViews()
        self.mapView.delegate = self
        self.viewModel?.recordDidFetch = { [weak self] in
            guard let viewModel = self?.viewModel else { return }
            self?.titleLabel.text = viewModel.resultDetailData?.title
            self?.informationView.configureLayout(
                distance: viewModel.distanceViewModel.totalDistance,
                time: viewModel.timeViewModel.totalTimeSpent,
                steps: viewModel.distanceViewModel.steps,
                maxAltitude: viewModel.altitudeViewModel.highest,
                minAltitude: viewModel.altitudeViewModel.lowest,
                averageSpeed: viewModel.averageSpeed()
            )
        }
        viewModel?.setUp()
        
        guard let pointSets: [[CLLocationCoordinate2D]] = self.viewModel?.resultDetailData?.coordinates else {
            return
        }
        for pointSet in pointSets {
            mapView.addOverlay(MKPolyline(coordinates: pointSet, count: pointSet.count))
        }
        guard let initial = mapView.overlays.first?.boundingMapRect else { return }

            let mapRect = mapView.overlays
                .dropFirst()
                .reduce(initial) { $0.union($1.boundingMapRect) }

            mapView.setVisibleMapRect(mapRect, animated: true)
        print(pointSets.count)
        let startAnnotation = MKPointAnnotation()
        let endAnnotation = MKPointAnnotation()
        guard let startPoint = pointSets.first?.first,
              let endPoint = pointSets.last?.last else {
                  return
              }
        startAnnotation.coordinate = startPoint
        startAnnotation.title = "start"
        endAnnotation.coordinate = endPoint
        endAnnotation.title = "end"
        self.mapView.addAnnotations([startAnnotation, endAnnotation])
    }
    
    private func configureSmallerView() {
        self.informationView = ResultDetailSmallerInfoView(frame: self.informationView.bounds)
    }
    
    private func configureViews() {
        self.view.addSubview(self.mapView)
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.changeButton)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.informationView)
        NSLayoutConstraint.activate([
            self.mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.mapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -self.view.frame.height * 0.25)
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
            self.titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.changeButton.centerYAnchor),
        ])
        NSLayoutConstraint.activate([
            self.informationView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.informationView.topAnchor.constraint(equalTo: self.mapView.bottomAnchor),
            self.informationView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.informationView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func registerRecognizers() {
        let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(showSmallInfoView))
        swipeDownRecognizer.direction = .down
        self.informationView.addGestureRecognizer(swipeDownRecognizer)
        
        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(showLargeInfoView))
        swipeUpRecognizer.direction = .up
        self.informationView.addGestureRecognizer(swipeUpRecognizer)
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
            // TODO: 입력창 띄우고 텍스트 입력 받아서 update 호출
            self.coordinator?.presentRecordingTitleViewController()
//            self.viewModel?.update(title: "타이트을", completion: { title in
//                DispatchQueue.main.async {
//                    self.titleLabel.text = title
//                }
//            })
        }
        let delete = UIAlertAction(title: "삭제", style: .destructive) { action in
            self.viewModel?.delete { result in
                switch result {
                case .success():
                    DispatchQueue.main.async {
                        self.coordinator?.dismiss()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(changeTitle)
        alert.addAction(delete)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}

extension ResultDetailViewController: SetTitleDelegate {
    func didTitleWriteDone(title: String) {
        self.viewModel?.update(title: title, completion: { title in
            DispatchQueue.main.async {
                self.titleLabel.text = title
            }
        })
    }
}

extension ResultDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            print("is polyline")
            let renderer = MKPolylineRenderer(overlay: polyline)
            renderer.lineWidth = 5
            renderer.alpha = 1
            renderer.strokeColor = .init(named: "SantaColor")
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {
            return nil
        }
        
        let identifier = "PointAnnotation"
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        if annotation.title == "start" {
            annotationView.markerTintColor = .init(named: "SantaColor")
        } else {
            annotationView.markerTintColor = .red
        }
        annotationView.animatesWhenAdded = true
        return annotationView
    }
}
