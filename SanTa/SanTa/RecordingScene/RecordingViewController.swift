//
//  RecordingViewController.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import UIKit
import Combine

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
        return label
    }()
    
    let altitudeTextLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.text = "고도"
        return label
    }()
    
    let walkTextLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.text = "걸음"
        return label
    }()
    
    let pauseButton = UIButton()
    let stopButton = UIButton()
    let locationButton = UIButton()
    
    let calculateStackView = UIStackView()
    let calculateTextStackView = UIStackView()
    let buttonStackView = UIStackView()
    
    private var recordingViewModel = RecordingViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureLabel()
        self.configureStackView()
        self.configureConstraints()
        self.configureButton()
        self.configureBindings()
        self.configureTarget()
    }
    
    private func configureBindings() {
        self.recordingViewModel.$currentTime
            .receive(on: DispatchQueue.main)
            .sink (receiveValue: { [weak self] time in
                self?.timeLabel.text = time
            })
            .store(in: &self.subscriptions)
        
        self.recordingViewModel.$kilometer
            .receive(on: DispatchQueue.main)
            .sink (receiveValue: { [weak self] kilometer in
                self?.kilometerLabel.text = kilometer
            })
            .store(in: &self.subscriptions)
        
        self.recordingViewModel.$altitude
            .receive(on: DispatchQueue.main)
            .sink (receiveValue: { [weak self] altitude in
                self?.altitudeLabel.text = altitude
            })
            .store(in: &self.subscriptions)
        
        self.recordingViewModel.$walk
            .receive(on: DispatchQueue.main)
            .sink (receiveValue: { [weak self] walk in
                self?.walkLabel.text = walk
            })
            .store(in: &self.subscriptions)
    }
    
    private func configureTarget() {
        self.pauseButton.addTarget(self, action: #selector(pauseButtonAction), for: .touchUpInside)
        self.stopButton.addTarget(self, action: #selector(stopButtonAction), for: .touchUpInside)
    }
    
    @objc private func pauseButtonAction(_ sender: UIResponder) {
        
    }
    
    @objc private func stopButtonAction(_ sender: UIResponder) {
        let stopAlert = UIAlertController(title: "기록 종료", message: "기록을 종료합니다.", preferredStyle: UIAlertController.Style.alert)
        let noneAction = UIAlertAction(title: "아니요", style: .default)
        let terminationAction = UIAlertAction(title: "종료", style: .default) { [weak self] (action) in
            let resultRecord = self?.recordingViewModel.stopRecording()
            print(resultRecord)
            self.coordinator?.dismiss()
        }
        stopAlert.addAction(noneAction)
        stopAlert.addAction(terminationAction)
        present(stopAlert, animated: true, completion: nil)
    }
}
