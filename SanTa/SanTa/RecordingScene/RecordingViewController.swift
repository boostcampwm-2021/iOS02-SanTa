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
    }
    
    private func configureBindings() {
        recordingViewModel.$currentTime
            .receive(on: DispatchQueue.main)
            .sink (receiveCompletion: { print ("completion: \($0)") },
                   receiveValue: { [weak self] time in
                self?.timeLabel.text = time
            })
            .store(in: &subscriptions)
        
        recordingViewModel.$kilometer
            .receive(on: DispatchQueue.main)
            .sink (receiveCompletion: { print ("completion: \($0)") },
                   receiveValue: { [weak self] kilometer in
                self?.kilometerLabel.text = kilometer
            })
            .store(in: &subscriptions)
        
        recordingViewModel.$altitude
            .receive(on: DispatchQueue.main)
            .sink (receiveCompletion: { print ("completion: \($0)") },
                   receiveValue: { [weak self] altitude in
                self?.altitudeLabel.text = altitude
            })
            .store(in: &subscriptions)
        
        recordingViewModel.$walk
            .receive(on: DispatchQueue.main)
            .sink (receiveCompletion: { print ("completion: \($0)") },
                   receiveValue: { [weak self] walk in
                self?.walkLabel.text = walk
            })
            .store(in: &subscriptions)
    }
}
