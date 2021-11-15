//
//  MountainDetailTitleView.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/09.
//

import UIKit

class MountainDetailTitleView: UIView {
    private let titleLabel = UILabel()
    private let distanceLabel = UILabel()
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layoutTitleView()
        self.addShadow()
    }
    
    private func addShadow() {
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        print("add shadow")
    }

    private func layoutTitleView() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        distanceLabel.textColor = .lightGray
        self.addSubview(titleLabel)
        self.addSubview(distanceLabel)
        
        let titleConstraints = [
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20)
        ]
        NSLayoutConstraint.activate(titleConstraints)
        
        let distanceLabelConstraints = [
            distanceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            distanceLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20)
        ]
        NSLayoutConstraint.activate(distanceLabelConstraints)
    }
    
    func configure(with title: String, distance: Double?) {
        self.titleLabel.text = title
        guard let distance = distance else {
            self.distanceLabel.text = "현재 위치를 알 수 없어 산까지의 거리를 불러올 수 없습니다."
            return
        }
        let distanceRepresentation = String(format:"%.2f", distance)
        self.distanceLabel.text = "현재 위치로부터 약 \(distanceRepresentation)km (직선거리)"
    }
}
