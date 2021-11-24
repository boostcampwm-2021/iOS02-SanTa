//
//  SectionHeaderView.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/15.
//

import UIKit

extension UILabel {
    fileprivate convenience init(normalFontWithSize: CGFloat, withTextColor: UIColor) {
        self.init()
        self.font = .systemFont(ofSize: normalFontWithSize)
        self.textColor = withTextColor
    }
    
    fileprivate convenience init(boldFontWithSize: CGFloat, withTextColor: UIColor) {
        self.init()
        self.font = .boldSystemFont(ofSize: boldFontWithSize)
        self.textColor = withTextColor
    }
}

class SectionHeaderView: UICollectionReusableView {
    static let identifier = "SectionHeaderView"
    let monthLabel = UILabel(boldFontWithSize: 17, withTextColor: .label)
    let countLabel = UILabel(normalFontWithSize: 15, withTextColor: .systemGray)
    let distanceLabel = UILabel(normalFontWithSize: 15, withTextColor: .systemGray)
    let timeLabel = UILabel(normalFontWithSize: 15, withTextColor: .systemGray)
    
    func configure(month: String, count: String, distance: String, time: String) {
        self.backgroundColor = .systemBackground
        self.monthLabel.text = month
        self.countLabel.text = count
        self.distanceLabel.text = distance
        self.timeLabel.text = time
        
        self.configureSubviews()
        self.configureLayout()
    }
    
    private func configureSubviews(){
        self.addSubview(self.monthLabel)
        self.addSubview(self.countLabel)
        self.addSubview(self.distanceLabel)
        self.addSubview(self.timeLabel)
    }
    
    private func configureLayout() {
        self.monthLabel.translatesAutoresizingMaskIntoConstraints = false
        self.countLabel.translatesAutoresizingMaskIntoConstraints = false
        self.distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.monthLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.monthLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            self.timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            self.distanceLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.distanceLabel.rightAnchor.constraint(equalTo: self.timeLabel.leftAnchor, constant: -10),
            self.countLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.countLabel.rightAnchor.constraint(equalTo: self.distanceLabel.leftAnchor, constant: -10)
        ])
    }
}

// MARK: - Accessibility

extension SectionHeaderView {
    
    func configureVoiceOverAccessibility(date: String) {
        guard let countLabel = self.countLabel.text else { return }
        guard let distanceLabel = self.distanceLabel.text else { return }
        guard let timeLabel = self.timeLabel.text else { return }
        self.isAccessibilityElement = true
        self.accessibilityLabel = "\(date) 등산기록 정보, 총 등산횟수: \(countLabel), 총 거리: \(distanceLabel), 총 시간: \(timeLabel)"
        self.accessibilityTraits = .none
    }
}
