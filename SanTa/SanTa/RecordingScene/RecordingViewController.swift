//
//  RecordingViewController.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import UIKit

class RecordingViewController: UIViewController {
    weak var coordinator: RecordingViewCoordinator?
    
    let kilometerLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 110)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.text = "0.00"
        label.textColor = .white
        return label
    }()
    
    let kilometerTextLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "킬로미터"
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00 00\""
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let altitudeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let walkLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let timeTextLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "시간"
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let altitudeTextLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "고도"
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let walkTextLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "걸음"
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    
    let calculateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually

        return stackView
    }()
    
    
    let calculateTextStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually

        return stackView
    }()
    
    let pauseButton = UIButton()
    let stopButton = UIButton()
    let locationButton = UIButton()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 18
        stackView.distribution = .fill
        stackView.alignment = .center

        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureConstraints()
        self.configureButton()
    }
}
