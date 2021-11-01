//
//  RecordingViewController+Extension.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/01.
//

import UIKit

extension RecordingViewController {
    func configureViews() {
        self.view.backgroundColor = .systemBlue
        
        [self.timeLabel, self.altitudeLabel, self.walkLabel].forEach {
            self.calculateStackView.addArrangedSubview($0)
        }
        
        [self.timeTextLabel, self.altitudeTextLabel, self.walkTextLabel].forEach {
            self.calculateTextStackView.addArrangedSubview($0)
        }
        
        self.view.addSubview(kilometerLabel)
        self.view.addSubview(kilometerTextLabel)
        self.view.addSubview(calculateStackView)
        self.view.addSubview(calculateTextStackView)
        
        let kilometerLabelConstraints = [
            self.kilometerLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80),
            self.kilometerLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width/2 + 30),
            self.kilometerLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ]
        
        let kilometerTextLabelConstraints = [
            self.kilometerTextLabel.topAnchor.constraint(equalTo: self.kilometerLabel.bottomAnchor, constant: 16),
            self.kilometerTextLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ]

        let calculateStackViewConstraints = [
            self.calculateStackView.topAnchor.constraint(equalTo: self.kilometerTextLabel.bottomAnchor, constant: 64),
            self.calculateStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.calculateStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
            self.calculateStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8)
        ]

        let calculateTextStackViewConstraints = [
            self.calculateTextStackView.topAnchor.constraint(equalTo: self.calculateStackView.bottomAnchor, constant: 8),
            self.calculateTextStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.calculateTextStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
            self.calculateTextStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8)
        ]
        
        NSLayoutConstraint.activate(kilometerLabelConstraints)
        NSLayoutConstraint.activate(kilometerTextLabelConstraints)
        NSLayoutConstraint.activate(calculateStackViewConstraints)
        NSLayoutConstraint.activate(calculateTextStackViewConstraints)
    }
}
