//
//  TotalRecordsViewCell.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/15.
//

import UIKit

extension UILabel {
    fileprivate convenience init(normalFontWithSize: CGFloat) {
        self.init()
        self.font = .systemFont(ofSize: normalFontWithSize)
    }

    fileprivate convenience init(text: String, normalFontWithSize: CGFloat) {
        self.init()
        self.text = text
        self.font = .systemFont(ofSize: normalFontWithSize)
    }
}

class TotalRecordsViewCell: UICollectionViewCell {
    static let identifier = "TotalRecordsInfoCell"
    let kilometerNumber = UILabel(normalFontWithSize: 60)
    let kilometer = UILabel(text: "킬로미터", normalFontWithSize: 25)
    let countNumber = UILabel(normalFontWithSize: 25)
    let count = UILabel(text: "횟수", normalFontWithSize: 15)
    let timeNumber = UILabel(normalFontWithSize: 25)
    let time = UILabel(text: "시간", normalFontWithSize: 15)
    let stepsNumber = UILabel(normalFontWithSize: 25)
    let steps = UILabel(text: "걸음", normalFontWithSize: 15)
    let horizontalStackView = UIStackView()
    let countVerticalStackView = UIStackView()
    let timeVerticalStackView = UIStackView()
    let stepsVerticalStackView = UIStackView()

    func configure(distance: String, count: String, time: String, steps: String) {
        self.kilometerNumber.text = distance
        self.countNumber.text = count
        self.timeNumber.text = time
        self.stepsNumber.text = steps
        self.backgroundColor = .systemGray6

        self.configureSubviews()
        self.configureLayout()
        self.configureShadow()
    }

    private func configureSubviews() {
        self.addSubview(self.kilometerNumber)
        self.addSubview(self.kilometer)
        self.addSubview(self.horizontalStackView)
        self.horizontalStackView.addArrangedSubview(countVerticalStackView)
        self.horizontalStackView.addArrangedSubview(timeVerticalStackView)
        self.horizontalStackView.addArrangedSubview(stepsVerticalStackView)
        self.horizontalStackView.axis = .horizontal
        self.horizontalStackView.distribution = .fillEqually
        self.countVerticalStackView.addArrangedSubview(countNumber)
        self.countVerticalStackView.addArrangedSubview(count)
        self.timeVerticalStackView.addArrangedSubview(timeNumber)
        self.timeVerticalStackView.addArrangedSubview(time)
        self.stepsVerticalStackView.addArrangedSubview(stepsNumber)
        self.stepsVerticalStackView.addArrangedSubview(steps)
        [self.countVerticalStackView, self.timeVerticalStackView, self.stepsVerticalStackView].forEach {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = 5
        }
    }

    private func configureLayout() {
        self.kilometerNumber.translatesAutoresizingMaskIntoConstraints = false
        self.kilometer.translatesAutoresizingMaskIntoConstraints = false
        self.horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.kilometerNumber.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.kilometerNumber.topAnchor.constraint(equalTo: self.topAnchor, constant: 60),
            self.kilometer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.kilometer.topAnchor.constraint(equalTo: self.kilometerNumber.bottomAnchor, constant: 0),
            self.horizontalStackView.topAnchor.constraint(equalTo: self.kilometer.bottomAnchor, constant: 50),
            self.horizontalStackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.horizontalStackView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.horizontalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30)
        ])
    }

    private func configureShadow() {
        let border = CALayer()
        border.frame = CGRect.init(x: 0, y: self.frame.height, width: self.frame.width, height: -1)
        border.backgroundColor = UIColor.systemGray4.cgColor
        self.layer.addSublayer(border)
    }
}

// MARK: - Accessibility

extension TotalRecordsViewCell {

    func configureVoiceOverAccessibility() {
        guard let kilometerNumber = kilometerNumber.text else { return }
        guard let countNumber = countNumber.text else { return }
        guard let timeNumber = timeNumber.text else { return }
        guard let stepsNumber = stepsNumber.text else { return }
        self.isAccessibilityElement = true
        self.accessibilityLabel = "전체 등산기록 정보, 총 거리: \(kilometerNumber)km, 총 등산횟수: \(countNumber), 총 시간: \(timeNumber), 총 걸음: \(stepsNumber)"
    }
}
