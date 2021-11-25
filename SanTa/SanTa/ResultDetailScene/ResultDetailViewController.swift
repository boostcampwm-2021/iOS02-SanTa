//
//  ViewController.swift
//  SwipeView
//
//  Created by Jiwon Yoon on 2021/11/10.
//

import UIKit
import MapKit
import Photos

class ResultDetailViewController: UIViewController {
    
    weak var coordinator: ResultDetailViewCoordinator?
    
    private var viewModel: ResultDetailViewModel?
    
    private var infoViewTopConstraint: NSLayoutConstraint?
    private var infoViewHight: CGFloat?
    private var isLargeInfoView = false
    
    private let imageManager = PHCachingImageManager()
    private var uiImages = [String: UIImage]()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = .mutedStandard
        mapView.backgroundColor = .black
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        return mapView
    }()
    
    private lazy var smallerInformationView: ResultDetailSmallerInfoView = {
        let view = ResultDetailSmallerInfoView(frame: CGRect(x: 0,
                                                             y: 0,
                                                             width: self.view.frame.width,
                                                             height: self.view.frame.height))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var largerInformationView: ResultDetailLargerInfoView = {
        let view = ResultDetailLargerInfoView(frame: CGRect(x: 0,
                                                            y: 0,
                                                            width: self.view.frame.width,
                                                            height: self.view.frame.height))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "chevron.backward"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 25), forImageIn: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        return button
    }()
    
    private lazy var changeButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "ellipsis.circle"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 25), forImageIn: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(presentModifyResultAlert), for: .touchUpInside)
        return button
    }()
    
    private lazy var detailImagesButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "photo.on.rectangle.angled"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 14), forImageIn: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.backgroundColor = .systemBackground
        button.tintColor = .label
        button.setTitleColor(.label, for: .normal)
        button.contentHorizontalAlignment = .center
        button.semanticContentAttribute = .forceLeftToRight
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowRadius = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pushDetailImagesViewController), for: .touchUpInside)
        return button
    }()
    
    private lazy var imagesVisibilityButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "eye"), for: .normal)
        //eye.slash
        button.setPreferredSymbolConfiguration(.init(pointSize: 14), forImageIn: .normal)
        button.backgroundColor = .systemBackground
        button.tintColor = .label
        button.contentHorizontalAlignment = .center
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowRadius = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(imagesVisibilityButtonAction), for: .touchUpInside)
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
        self.configureViewModel()
        self.drawPathOnMap()
        self.markEndPoints()
        self.registerAnnotationView()
    }
    
    private func configureViewModel() {
        self.viewModel?.recordDidFetch = { [weak self] in
            guard let viewModel = self?.viewModel else { return }
            self?.titleLabel.text = viewModel.resultDetailData?.title
            self?.smallerInformationView.configureLayout(
                distance: viewModel.distanceViewModel.totalDistance,
                time: viewModel.timeViewModel.totalTimeSpent,
                steps: viewModel.distanceViewModel.steps,
                maxAltitude: viewModel.altitudeViewModel.highest,
                minAltitude: viewModel.altitudeViewModel.lowest,
                averageSpeed: viewModel.averageSpeed()
            )
            self?.largerInformationView.configure()
            guard let distanceViewModel = self?.viewModel?.distanceViewModel,
                  let timeViewModel = self?.viewModel?.timeViewModel,
                  let paceViewModel = self?.viewModel?.paceViewModel,
                  let altitudeViewModel = self?.viewModel?.altitudeViewModel,
                  let inclineViewModel = self?.viewModel?.inclineViewMedel,
                  let recordDate = self?.viewModel?.recordDate,
                  let startTime = self?.viewModel?.startTime,
                  let endTime = self?.viewModel?.endTime else {
                      return
                  }
            self?.largerInformationView.configureHeaderInformation(date: recordDate, startTime: startTime, endTime: endTime)
            let largeInfoModel: [DetailInformationModel] = [
                distanceViewModel, timeViewModel, paceViewModel, altitudeViewModel, inclineViewModel
            ]
            self?.largerInformationView.bindSnapShotApply(section: .main, item: largeInfoModel)
            self?.configureViews()
            self?.configurePanGesture()
        }
        viewModel?.setUp()
    }
    
    private func registerAnnotationView() {
        self.mapView.register(
            ThumbnailView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier
        )
    }
    
    private func drawPathOnMap() {
        guard let pointSets: [[CLLocationCoordinate2D]] = self.viewModel?.resultDetailData?.coordinates else {
            return
        }
        for pointSet in pointSets {
            mapView.addOverlay(MKPolyline(coordinates: pointSet, count: pointSet.count))
        }
        guard let initial = mapView.overlays.first?.boundingMapRect else {
            return
        }
        
        let mapRect = mapView.overlays.dropFirst().reduce(initial) { $0.union($1.boundingMapRect) }
        mapView.setVisibleMapRect(mapRect, animated: true)
    }
    
    private func markEndPoints() {
        guard let startingLocation = self.viewModel?.resultDetailData?.timeStamp.startLocation,
              let endingLocation = self.viewModel?.resultDetailData?.timeStamp.endLocation else {
                  return
              }
        let startAnnotation = MKPointAnnotation()
        let endAnnotation = MKPointAnnotation()
        let startingPoint = CLLocationCoordinate2D(latitude: startingLocation.latitude, longitude: startingLocation.longitude)
        let endingPoint = CLLocationCoordinate2D(latitude: endingLocation.latitude, longitude: endingLocation.longitude)
        startAnnotation.coordinate = startingPoint
        startAnnotation.title = "start"
        endAnnotation.coordinate = endingPoint
        endAnnotation.title = "end"
        self.fetchAssetImage()
        self.mapView.addAnnotations([startAnnotation, endAnnotation])
    }
    
    private func fetchAssetImage() {
        guard let assetIdentifiers = self.viewModel?.resultDetailData?.assetIdentifiers else { return }
        let allMedia = PHAsset.fetchAssets(with: .image, options: nil)
        var identifierIndex = 0
        self.detailImagesButton.setTitle("\(assetIdentifiers.count)", for: .normal)
        for i in stride(from: allMedia.count - 1, through: 0, by: -1) {
            guard identifierIndex < assetIdentifiers.count else { return }
            if allMedia[i].localIdentifier == assetIdentifiers[identifierIndex] {
                requestAssetIamge(with: allMedia[i]) { [weak self] (image, asset) in
                    guard let image = image,
                          let identifier = asset?.localIdentifier,
                          let coordinate = asset?.location?.coordinate else { return }
                    self?.uiImages[identifier] = image
                    self?.appendImageAnnotation(identifier: identifier, location: coordinate)
                }
                identifierIndex += 1
            }
        }
    }
    
    private func requestAssetIamge(with asset: PHAsset?, completion: @escaping (UIImage?, PHAsset?) -> Void) {
        guard let asset = asset else {
            completion(nil, nil)
            return
        }
        let thumbnailSize = CGSize(width: 1000, height: 1000)
        self.imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            completion(image, asset)
        })
    }
    
    private func appendImageAnnotation(identifier: String, location: CLLocationCoordinate2D) {
        let imageAnnotation = MKPointAnnotation()
        imageAnnotation.coordinate = location
        imageAnnotation.title = identifier
        mapView.addAnnotation(imageAnnotation)
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
        self.view.addSubview(self.detailImagesButton)
        self.view.addSubview(self.imagesVisibilityButton)
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.changeButton)
        self.view.addSubview(self.largerInformationView)
        self.view.addSubview(self.smallerInformationView)
        self.view.addSubview(self.titleLabel)
        
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
            self.largerInformationView.bottomAnchor.constraint(equalTo: self.smallerInformationView.bottomAnchor),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.changeButton.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            self.detailImagesButton.topAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: -45),
            self.detailImagesButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            self.detailImagesButton.widthAnchor.constraint(equalToConstant: 55),
            self.detailImagesButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            self.imagesVisibilityButton.topAnchor.constraint(equalTo: self.detailImagesButton.topAnchor),
            self.imagesVisibilityButton.trailingAnchor.constraint(equalTo: self.detailImagesButton.leadingAnchor, constant: -15),
            self.imagesVisibilityButton.widthAnchor.constraint(equalToConstant: 55),
            self.imagesVisibilityButton.heightAnchor.constraint(equalToConstant: 30)
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
    
    @objc func pushDetailImagesViewController() {
        coordinator?.pushResultDetailImagesViewController(uiImages: uiImages)
    }
    
    @objc func imagesVisibilityButtonAction() {
        
    }
    
    @objc func presentModifyResultAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let changeTitle = UIAlertAction(title: "제목 변경", style: .default) { action in
            self.coordinator?.presentRecordingTitleViewController()
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
        
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        if annotation.title == "start" {
            annotationView.tintColor = .init(named: "SantaColor")
        } else if annotation.title == "end" {
            annotationView.tintColor = .red
        } else {
            guard let identifider = annotation.title,
                  let image = self.uiImages[identifider ?? "None"] else {
                return nil
            }
            
            let thumbnailView = ThumbnailView(annotation: annotation, reuseIdentifier: identifier)
            thumbnailView.configureImage(uiImage: image, id: identifider ?? "")
            
            return thumbnailView
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view as? ThumbnailView else { return }
        
        self.coordinator?.presentResultDetailThumbnailViewController(uiImages: uiImages, id: annotation.imageIdentifier)
    }
}
