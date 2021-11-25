//
//  RecordingViewController.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import UIKit
import Combine
import Photos

protocol SetTitleDelegate: AnyObject {
    func didTitleWriteDone(title: String)
}

protocol RecordingViewDelegate: SetTitleDelegate {
    func didAgreeButtonTouchDone()
}

class RecordingViewController: UIViewController {
    weak var coordinator: RecordingViewCoordinator?
    
    let kilometerLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 110)
        label.adjustsFontSizeToFitWidth = true
        label.text = "0.00"
        return label
    }()
    
    let kilometerTextLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.text = "킬로미터"
        label.isAccessibilityElement = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.text = "00:00 00\""
        return label
    }()
    
    let altitudeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.text = "0"
        return label
    }()
    
    let walkLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.text = "0"
        return label
    }()
    
    let timeTextLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.text = "시간"
        label.isAccessibilityElement = false
        return label
    }()
    
    let altitudeTextLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.text = "고도"
        label.isAccessibilityElement = false
        return label
    }()
    
    let walkTextLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.text = "걸음"
        label.isAccessibilityElement = false
        return label
    }()
    
    let pauseButton = UIButton()
    let stopButton = UIButton()
    let locationButton = UIButton()
    
    let calculateStackView = UIStackView()
    let calculateTextStackView = UIStackView()
    let buttonStackView = UIStackView()
    
    private var recordingViewModel: RecordingViewModel?
    private var subscriptions = Set<AnyCancellable>()
    private var isCoreLocationStatus = true
    
    convenience init(viewModel: RecordingViewModel) {
        self.init()
        self.recordingViewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureLabel()
        self.configureStackView()
        self.configureConstraints()
        self.configureButton()
        self.configureBindings()
        self.configureTarget()
        self.configureAccessibilty()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.configureAlbumPermission()
        self.recordingViewModel?.fetchOptions()
    }
    
    private func configureBindings() {
        self.recordingViewModel?.$currentTime
            .receive(on: DispatchQueue.main)
            .sink (receiveValue: { [weak self] time in
                self?.timeLabel.text = time
            })
            .store(in: &self.subscriptions)
        
        self.recordingViewModel?.$accessibilityCurrentTime
            .receive(on: DispatchQueue.main)
            .sink (receiveValue: { [weak self] time in
                self?.timeLabel.accessibilityLabel = "현재 시간 \(time)"
            })
            .store(in: &self.subscriptions)
        
        self.recordingViewModel?.$kilometer
            .receive(on: DispatchQueue.main)
            .sink (receiveValue: { [weak self] kilometer in
                self?.kilometerLabel.text = kilometer
                self?.kilometerLabel.accessibilityLabel = "현재 \(kilometer)km"
            })
            .store(in: &self.subscriptions)
        
        self.recordingViewModel?.$altitude
            .receive(on: DispatchQueue.main)
            .sink (receiveValue: { [weak self] altitude in
                self?.altitudeLabel.text = altitude
                self?.altitudeLabel.accessibilityLabel = "현재 고도 \(altitude)"
            })
            .store(in: &self.subscriptions)
        
        self.recordingViewModel?.$walk
            .receive(on: DispatchQueue.main)
            .sink (receiveValue: { [weak self] walk in
                self?.walkLabel.text = walk
                self?.walkLabel.accessibilityLabel = "현재 \(walk) 걸음"
            })
            .store(in: &self.subscriptions)
        
        self.recordingViewModel?.$gpsStatus
            .receive(on: DispatchQueue.main)
            .sink (receiveValue: { [weak self] gpsStatus in
                if gpsStatus != self?.isCoreLocationStatus {
                    if !gpsStatus {
                        let title = "위치정보 활성화"
                        let message = "측정을 다시 시작할 수 있도록 위치정보를 활성화해주세요."
                        guard let alert = self?.authAlert(title: title, message: message) else { return }
                        DispatchQueue.main.async {
                            self?.present(alert, animated: false)
                        }
                    }
                    self?.changeRecordingStatus()
                }
            })
            .store(in: &self.subscriptions)
        
        self.recordingViewModel?.$motionAuth
            .receive(on: DispatchQueue.main)
            .sink (receiveValue: { [weak self] motionAuth in
                self?.requestMotionAuth(status: motionAuth)
            })
            .store(in: &self.subscriptions)
    }
    
    private func configureTarget() {
        self.pauseButton.addTarget(self, action: #selector(pauseButtonAction), for: .touchUpInside)
        self.stopButton.addTarget(self, action: #selector(stopButtonAction), for: .touchUpInside)
        self.locationButton.addTarget(self, action: #selector(locationButtonAction), for: .touchUpInside)
    }
    
    private func configureAlbumPermission() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status{
        case .notDetermined:
            self.coordinator?.presentRecordingPhotoViewController()
        default:
            break
        }
    }
    
    private func changeRecordingStatus() {
        if isCoreLocationStatus {
            self.view.backgroundColor = .black
            var pauseConfiguration = UIButton.Configuration.plain()
            pauseConfiguration.image = UIImage(systemName: "play.fill")
            pauseConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            self.pauseButton.configuration = pauseConfiguration
            self.pauseButton.accessibilityLabel = "재시작"
            self.pauseButton.accessibilityHint = "측정을 재시작 하려면 이중 탭 하십시오"
            self.recordingViewModel?.pause()
            self.isCoreLocationStatus = false
        } else {
            self.view.backgroundColor = UIColor(named: "SantaColor")
            var pauseConfiguration = UIButton.Configuration.plain()
            pauseConfiguration.image = UIImage(systemName: "pause.fill")
            pauseConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            self.pauseButton.configuration = pauseConfiguration
            self.pauseButton.accessibilityLabel = "일시정지"
            self.pauseButton.accessibilityHint = "측정을 일시정지 하려면 이중 탭 하십시오"
            self.recordingViewModel?.resume()
            self.isCoreLocationStatus = true
        }
    }
    
    private func authAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "아니요", style: .cancel)
        let confirm = UIAlertAction(title: "활성화", style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        }
        alert.addAction(cancel)
        alert.addAction(confirm)
        return alert
    }
    
    private func requestMotionAuth(status: Bool) {
        if !status {
            let title = "동작 및 피트니스 활성화"
            let message = "측정을 시작할 수 있도록 동작 및 피트니스를 활성화해주세요."
            DispatchQueue.main.async {
                self.present(self.authAlert(title: title, message: message), animated: false)
            }
        }
    }

    @objc private func pauseButtonAction(_ sender: UIResponder) {
        changeRecordingStatus()
    }
    
    @objc private func stopButtonAction(_ sender: UIResponder) {
        let stopAlert = UIAlertController(title: "기록 종료", message: "기록을 종료합니다.", preferredStyle: UIAlertController.Style.alert)
        let noneAction = UIAlertAction(title: "아니요", style: .default)
        let terminationAction = UIAlertAction(title: "종료", style: .default) { [weak self] (action) in
            self?.view.backgroundColor = .black
            self?.recordingViewModel?.pause()
            self?.coordinator?.presentRecordingTitleViewController()
        }
        stopAlert.addAction(noneAction)
        stopAlert.addAction(terminationAction)
        present(stopAlert, animated: true, completion: nil)
    }
    
    @objc private func locationButtonAction(_ sender: UIResponder) {
        self.coordinator?.hide()
    }
    
    deinit {
        print("😇RecordingViewController is deinit \(Date())!!😇")
    }
}

extension RecordingViewController: RecordingViewDelegate {
    func didTitleWriteDone(title: String) {
        self.recordingViewModel?.save(title: title) { [weak self] completion in
            switch completion {
            case .success(_):
                DispatchQueue.main.async {
                    self?.coordinator?.dismiss()
                }
            case .failure(_):
                let resultAlert = UIAlertController(title: "저장 실패", message: "데이터 저장에 실패했습니다.", preferredStyle: UIAlertController.Style.alert)
                let restoreAction = UIAlertAction(title: "다시 저장하기", style: .default) { [weak self] (action) in
                    self?.didTitleWriteDone(title: title)
                }
                let endAction = UIAlertAction(title: "저장하지 않기", style: .destructive) { [weak self] (action) in
                    DispatchQueue.main.async {
                        self?.coordinator?.dismiss()
                    }
                }
                resultAlert.addAction(restoreAction)
                resultAlert.addAction(endAction)
                DispatchQueue.main.async {
                    self?.present(resultAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func didAgreeButtonTouchDone() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                self.recordingViewModel?.saveRecordPhotoOption(value: true)
            case .notDetermined, .restricted, .denied, .limited:
                self.recordingViewModel?.saveRecordPhotoOption(value: false)
            @unknown default:
                self.recordingViewModel?.saveRecordPhotoOption(value: false)
            }
        }
    }
}
