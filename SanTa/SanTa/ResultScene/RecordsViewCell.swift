//
//  RecordsViewCell.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/15.
//

import UIKit

extension UILabel {
    fileprivate convenience init(text: String, normalFontWithSize: CGFloat) {
        self.init()
        self.text = text
        self.textColor = .label
    }
    
    fileprivate convenience init(boldFontWithSize: CGFloat) {
        self.init()
        self.font = .boldSystemFont(ofSize: boldFontWithSize)
        self.textColor = .label
    }
}

class RecordsViewCell: UICollectionViewCell {
    static let identifier = "RecordsViewCell"
    let date: PaddingLabel = {
        let paddingLabel = PaddingLabel()
        paddingLabel.padding(top: 2, bottom: 2, left: 3, right: 3)
        paddingLabel.backgroundColor = UIColor(named: "SantaColor")
        paddingLabel.layer.cornerRadius = 3
        paddingLabel.textColor = .white
        paddingLabel.font = .boldSystemFont(ofSize: 13)
        paddingLabel.clipsToBounds = true
        return paddingLabel
    }()
    let distance = UILabel(boldFontWithSize: 20)
    let time = UILabel(boldFontWithSize: 20)
    let altitude = UILabel(boldFontWithSize: 20)
    let steps = UILabel(boldFontWithSize: 20)
    let distanceLabel = UILabel(text: "거리", normalFontWithSize: 15)
    let timeLabel = UILabel(text: "시간", normalFontWithSize: 15)
    let altitudeLabel = UILabel(text: "고도차", normalFontWithSize: 15)
    let stepsLabel = UILabel(text: "걸음", normalFontWithSize: 15)
    let horizontalStackView = UIStackView()
    let distanceStackView = UIStackView()
    let timeStackView = UIStackView()
    let altitudeStackView = UIStackView()
    let stepsStackView = UIStackView()
    
    func configure(date: String, distance: String, time: String, altitude: String, steps: String) {
        self.date.text = date
        self.distance.text = distance
        self.time.text = time
        self.altitude.text = altitude
        self.steps.text = steps
        self.backgroundColor = UIColor(named: "RecodingResultCellColor")
        
        self.configureSubviews()
        self.configureLayout()
    }
    
    private func configureSubviews() {
        self.addSubview(date)
        self.addSubview(horizontalStackView)
        self.horizontalStackView.distribution = .fillEqually
        self.horizontalStackView.axis = .horizontal
        self.horizontalStackView.addArrangedSubview(distanceStackView)
        self.horizontalStackView.addArrangedSubview(timeStackView)
        self.horizontalStackView.addArrangedSubview(altitudeStackView)
        self.horizontalStackView.addArrangedSubview(stepsStackView)
        self.distanceStackView.addArrangedSubview(distance)
        self.distanceStackView.addArrangedSubview(distanceLabel)
        self.timeStackView.addArrangedSubview(time)
        self.timeStackView.addArrangedSubview(timeLabel)
        self.altitudeStackView.addArrangedSubview(altitude)
        self.altitudeStackView.addArrangedSubview(altitudeLabel)
        self.stepsStackView.addArrangedSubview(steps)
        self.stepsStackView.addArrangedSubview(stepsLabel)
        [self.distanceStackView, self.timeStackView, self.altitudeStackView, self.stepsStackView].forEach {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = 5
        }
    }
    
    private func configureLayout() {
        self.date.translatesAutoresizingMaskIntoConstraints = false
        self.horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.date.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            self.date.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            self.horizontalStackView.topAnchor.constraint(greaterThanOrEqualTo: self.date.bottomAnchor, constant: 10),
            self.horizontalStackView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -15),
            self.horizontalStackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.horizontalStackView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
}
