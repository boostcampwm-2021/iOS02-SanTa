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
        view.translatesAutoresizingMaskIntoConstraints = false
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
        label.accessibilityTraits = .header
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
        button.accessibilityHint = "사진 기록하기를 허용하려면 이중 탭 하십시오"
        return button
    }()

    private let photoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.axis = .vertical
        stackView.distribution = .fill
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

        [self.recordingPhotoTitle, self.recordingPhotoImage, self.recordingPhotoDescription, self.agreeButton].forEach {
            self.photoStackView.addArrangedSubview($0)
        }

        self.view.addSubview(displayView)
        self.displayView.addSubview(photoStackView)

        NSLayoutConstraint.activate([
            self.displayView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 6),
            self.displayView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -6),
            self.displayView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -64)
        ])

        NSLayoutConstraint.activate([
            self.recordingPhotoTitle.widthAnchor.constraint(equalToConstant: frameWidth - 12)
        ])

        NSLayoutConstraint.activate([
            self.recordingPhotoImage.widthAnchor.constraint(equalToConstant: frameWidth/3),
            self.recordingPhotoImage.heightAnchor.constraint(equalTo: self.recordingPhotoImage.widthAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            self.recordingPhotoDescription.widthAnchor.constraint(equalToConstant: frameWidth - 12)
        ])

        NSLayoutConstraint.activate([
            self.agreeButton.widthAnchor.constraint(equalToConstant: frameWidth - 12),
            self.agreeButton.heightAnchor.constraint(equalToConstant: frameWidth/8)
        ])

        NSLayoutConstraint.activate([
            self.photoStackView.topAnchor.constraint(equalTo: self.displayView.topAnchor, constant: 16),
            self.photoStackView.leadingAnchor.constraint(equalTo: self.displayView.leadingAnchor, constant: 16),
            self.photoStackView.trailingAnchor.constraint(equalTo: self.displayView.trailingAnchor, constant: -16),
            self.photoStackView.bottomAnchor.constraint(equalTo: self.displayView.bottomAnchor, constant: -16)
        ])
    }

    private func configureTarget() {
        self.agreeButton.addTarget(self, action: #selector(agreeButtonAction), for: .touchUpInside)
    }

    @objc private func agreeButtonAction(_ sender: UIButton) {
        self.delegate?.didAgreeButtonTouchDone()
        self.coordinator?.dismiss()
    }
}
