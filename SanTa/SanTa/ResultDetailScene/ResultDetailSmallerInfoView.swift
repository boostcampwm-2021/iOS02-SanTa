//
//  SwipeViewBefore.swift
//  SwipeView
//
//  Created by Jiwon Yoon on 2021/11/10.
//

import UIKit

class ResultDetailSmallerInfoView: UIView {

    private let distance = UILabel()
    private let time = UILabel()
    private let steps = UILabel()
    private let maxAltitude = UILabel()
    private let minAltitude = UILabel()
    private let averageSpeed = UILabel()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "킬로미터"
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "시간"
        return label
    }()
    
    private let stepsLabel: UILabel = {
        let label = UILabel()
        label.text = "걸음"
        return label
    }()
    
    private let maxAltitudeLabel: UILabel = {
        let label = UILabel()
        label.text = "최고 고도"
        return label
    }()
    
    private let minAltitudeLabel: UILabel = {
        let label = UILabel()
        label.text = "최저 고도"
        return label
    }()
    
    private let averageSpeedLabel: UILabel = {
        let label = UILabel()
        label.text = "평균 속도"
        return label
    }()
    
    private lazy var distanceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.distance, self.distanceLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var timeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.time, self.timeLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var stepsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.steps, self.stepsLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var maxAltitudeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.maxAltitude, self.maxAltitudeLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var minAltitudeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.minAltitude, self.minAltitudeLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var averageSpeedStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.averageSpeed, self.averageSpeedLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var firstHorizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.distanceStackView, self.timeStackView, self.stepsStackView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var secondHorizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.maxAltitudeStackView, self.minAltitudeStackView, self.averageSpeedStackView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var compositionalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.firstHorizontalStackView, self.secondHorizontalStackView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    func configureLayout(distance: String, time: String, steps: String, maxAltitude: String, minAltitude: String, averageSpeed: String) {
        self.backgroundColor = .systemBackground
        self.distance.text = distance
        self.time.text = time
        self.steps.text = steps
        self.maxAltitude.text = maxAltitude
        self.minAltitude.text = minAltitude
        self.averageSpeed.text = averageSpeed
        self.addSubview(self.compositionalStackView)
        NSLayoutConstraint.activate([
            self.compositionalStackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.compositionalStackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.compositionalStackView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.compositionalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func displayArrowImage() {
        let arrow = UIImage(systemName: "chevron.compact.up")?.withTintColor(.black)
        let imageView = UIImageView(image: arrow)
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let arrowConstraints = [
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 20)
        ]
        NSLayoutConstraint.activate(arrowConstraints)
    }
}
