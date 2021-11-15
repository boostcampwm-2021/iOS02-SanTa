//
//  RecordingPhotoViewController.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/14.
//

import UIKit

class RecordingPhotoViewController: UIViewController {
    weak var coordinator: RecordingPhotoViewCoordinator?
    weak var delegate: RecordingViewDelegate?
    
    private var displayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "RecordingSubViewBackgroundColor")
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let recordingPhotoImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "camera.fill")
        image.tintColor = .systemBlue
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let recordingPhotoTitle: UILabel = {
        let label = UILabel()
        label.text = "사진 기록하기"
        label.font = .preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let recordingPhotoDescription: UILabel = {
        let label = UILabel()
        label.text = "사진을 찍으면 지도에 표시됩니다."
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let agreeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("허용하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 6
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let photoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureConstraints()
        self.configureTarget()
    }
    
    private func configureConstraints() {
        let frameWidth = view.frame.width
        let frameHeight = view.frame.height
        
        self.displayView.frame = CGRect(x: 6, y: frameWidth, width: frameWidth - 12, height: frameHeight/2 - 64)
        
        [self.recordingPhotoTitle, self.recordingPhotoImage, self.recordingPhotoDescription, self.agreeButton].forEach {
            self.photoStackView.addArrangedSubview($0)
        }
        
        self.view.addSubview(displayView)
        self.displayView.addSubview(photoStackView)
        
        let recordingPhotoTitleConstraints = [
            self.recordingPhotoTitle.widthAnchor.constraint(equalToConstant: frameWidth - 12)
        ]

        let recordingPhotoImageConstraints = [
            self.recordingPhotoImage.widthAnchor.constraint(equalToConstant: frameWidth/3),
            self.recordingPhotoImage.heightAnchor.constraint(equalTo: self.recordingPhotoImage.widthAnchor, constant: -16)
        ]

        let recordingPhotoDescriptionText = [
            self.recordingPhotoDescription.widthAnchor.constraint(equalToConstant: frameWidth - 12)
        ]

        let agreeButtonConstraints = [
            self.agreeButton.widthAnchor.constraint(equalToConstant: frameWidth - 12)
        ]
        
        let titleStackViewConstraints = [
            self.photoStackView.topAnchor.constraint(equalTo: self.displayView.topAnchor, constant: 16),
            self.photoStackView.leadingAnchor.constraint(equalTo: self.displayView.leadingAnchor, constant: 16),
            self.photoStackView.trailingAnchor.constraint(equalTo: self.displayView.trailingAnchor, constant: -16),
            self.photoStackView.bottomAnchor.constraint(equalTo: self.displayView.bottomAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(recordingPhotoTitleConstraints)
        NSLayoutConstraint.activate(recordingPhotoImageConstraints)
        NSLayoutConstraint.activate(recordingPhotoDescriptionText)
        NSLayoutConstraint.activate(agreeButtonConstraints)
        NSLayoutConstraint.activate(titleStackViewConstraints)
    }
    
    private func configureTarget() {
        self.agreeButton.addTarget(self, action: #selector(agreeButtonAction), for: .touchUpInside)
    }
    
    @objc private func agreeButtonAction(_ sender: UIButton) {
        self.delegate?.didAgreeButtonTouchDone()
    }
}
