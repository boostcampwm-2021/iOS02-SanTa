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
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let recordingPhotoTitle: UILabel = {
        let label = UILabel()
        label.text = "사진 기록하기"
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let recordingPhotoDescription: UILabel = {
        let label = UILabel()
        label.text = "사진을 찍으면 지도에 표시됩니다."
        label.font = .preferredFont(forTextStyle: .body)
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

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
