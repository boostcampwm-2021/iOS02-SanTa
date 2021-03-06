//
//  RecordingViewController+Extension.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/01.
//

import UIKit

extension RecordingViewController {
    func configureButton() {
        [self.pauseButton, self.stopButton, self.locationButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.tintColor = .white
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = $0.frame.width/2
        }

        var pauseConfiguration = UIButton.Configuration.plain()
        pauseConfiguration.image = UIImage(systemName: "pause.fill")
        pauseConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        self.pauseButton.backgroundColor = .black
        self.pauseButton.configuration = pauseConfiguration

        self.stopButton.backgroundColor = .black
        self.stopButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        self.locationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
    }

    func configureLabel() {
        [self.kilometerLabel, self.kilometerTextLabel, self.timeLabel, self.timeLabel, self.altitudeLabel, self.walkLabel, self.timeTextLabel, self.altitudeTextLabel, self.walkTextLabel].forEach {
            $0.textAlignment = .center
            $0.textColor = .white
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.adjustsFontSizeToFitWidth = true
        }
    }

    func configureStackView() {
        [self.calculateStackView, self.calculateTextStackView, self.buttonStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .horizontal
        }

        self.calculateStackView.spacing = 10
        self.calculateStackView.distribution = .fillEqually

        self.calculateTextStackView.spacing = 10
        self.calculateTextStackView.distribution = .fillEqually

        self.buttonStackView.spacing = 18
        self.buttonStackView.distribution = .fill
        self.buttonStackView.alignment = .center
    }

    func configureConstraints() {
        self.view.backgroundColor = UIColor(named: "SantaColor")

        [self.timeLabel, self.altitudeLabel, self.walkLabel].forEach {
            self.calculateStackView.addArrangedSubview($0)
        }

        [self.timeTextLabel, self.altitudeTextLabel, self.walkTextLabel].forEach {
            self.calculateTextStackView.addArrangedSubview($0)
        }

        [self.stopButton, self.pauseButton, self.locationButton].forEach {
            self.buttonStackView.addArrangedSubview($0)
        }

        self.view.addSubview(kilometerLabel)
        self.view.addSubview(kilometerTextLabel)
        self.view.addSubview(calculateStackView)
        self.view.addSubview(calculateTextStackView)
        self.view.addSubview(buttonStackView)

        NSLayoutConstraint.activate([
            self.kilometerLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80),
            self.kilometerLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width/2 + 30),
            self.kilometerLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            self.kilometerTextLabel.topAnchor.constraint(equalTo: self.kilometerLabel.bottomAnchor, constant: 16),
            self.kilometerTextLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            self.calculateStackView.topAnchor.constraint(equalTo: self.kilometerTextLabel.bottomAnchor, constant: 64),
            self.calculateStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.calculateStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
            self.calculateStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8)
        ])

        NSLayoutConstraint.activate([
            self.calculateTextStackView.topAnchor.constraint(equalTo: self.calculateStackView.bottomAnchor, constant: 8),
            self.calculateTextStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.calculateTextStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
            self.calculateTextStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8)
        ])

        NSLayoutConstraint.activate([
            self.pauseButton.heightAnchor.constraint(equalToConstant: self.view.frame.width/4),
            self.pauseButton.widthAnchor.constraint(equalToConstant: self.view.frame.width/4)
        ])

        NSLayoutConstraint.activate([
            self.stopButton.heightAnchor.constraint(equalToConstant: self.view.frame.width/6),
            self.stopButton.widthAnchor.constraint(equalToConstant: self.view.frame.width/6)
        ])

        NSLayoutConstraint.activate([
            self.locationButton.heightAnchor.constraint(equalToConstant: self.view.frame.width/6),
            self.locationButton.widthAnchor.constraint(equalToConstant: self.view.frame.width/6)
        ])

        NSLayoutConstraint.activate([
            self.buttonStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.buttonStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80)
        ])

        self.view.layoutIfNeeded()
    }

    func configureAccessibilty() {
        self.pauseButton.accessibilityLabel = "일시 정지"
        self.pauseButton.accessibilityHint = "측정을 일시정지 하려면 이중 탭 하십시오"
        self.stopButton.accessibilityLabel = "종료"
        self.stopButton.accessibilityHint = "측정을 종료 하려면 이중 탭 하십시오"
        self.locationButton.accessibilityLabel = "현재 위치"
        self.locationButton.accessibilityHint = "시작화면에서 현재 위치를 보려면 이중 탭 하십시오"
    }
}
