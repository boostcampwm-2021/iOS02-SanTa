//
//  SwipeViewBefore.swift
//  SwipeView
//
//  Created by Jiwon Yoon on 2021/11/10.
//

import UIKit

class ResultDetailSmallerInfoView: UIView {

    private let distance: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: label.font.pointSize, weight: .bold)
        return label
    }()
    private let time: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: label.font.pointSize, weight: .bold)
        return label
    }()
    private let steps: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: label.font.pointSize, weight: .bold)
        return label
    }()
    private let maxAltitude: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: label.font.pointSize, weight: .bold)
        return label
    }()
    private let minAltitude: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: label.font.pointSize, weight: .bold)
        return label
    }()
    private let averageSpeed: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: label.font.pointSize, weight: .bold)
        return label
    }()
    
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
        stackView.spacing = 5
//        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var timeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.time, self.timeLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
//        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var stepsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.steps, self.stepsLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
//        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var maxAltitudeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.maxAltitude, self.maxAltitudeLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
//        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var minAltitudeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.minAltitude, self.minAltitudeLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
//        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var averageSpeedStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.averageSpeed, self.averageSpeedLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
//        stackView.distribution = .fillEqually
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
    
    lazy var compositionalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.firstHorizontalStackView, self.secondHorizontalStackView])
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    func configureLayout(distance: String, time: String, steps: String, maxAltitude: String, minAltitude: String, averageSpeed: String) {
        self.backgroundColor = .systemBackground
        self.distance.text = distance
        self.distance.font = .systemFont(ofSize: self.distance.font.pointSize, weight: .bold)
        self.time.text = time
        self.steps.text = steps
        self.maxAltitude.text = maxAltitude
        self.minAltitude.text = minAltitude
        self.averageSpeed.text = averageSpeed
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.addSubview(self.compositionalStackView)
        NSLayoutConstraint.activate([
            self.compositionalStackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.compositionalStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            self.compositionalStackView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
        self.displayUpDownMark()
        self.layoutIfNeeded()
    }
    
    private func displayUpDownMark() {
        let upDownView = UIView()
        upDownView.backgroundColor = .label
        upDownView.translatesAutoresizingMaskIntoConstraints = false
        upDownView.layer.cornerRadius = 2
        upDownView.layer.masksToBounds = true
        
        self.addSubview(upDownView)
        let upDownConstraints = [
            upDownView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            upDownView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            upDownView.heightAnchor.constraint(equalToConstant: 4),
            upDownView.widthAnchor.constraint(equalToConstant: self.frame.width/3)
        ]
        NSLayoutConstraint.activate(upDownConstraints)
    }
}
