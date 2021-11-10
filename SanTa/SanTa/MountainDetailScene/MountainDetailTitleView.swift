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
    }

    private func layoutTitleView() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(titleLabel)
        self.addSubview(distanceLabel)
        
        let titleConstraints = [
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]
        NSLayoutConstraint.activate(titleConstraints)
        
        let distanceLabelConstraints = [
            distanceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            distanceLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]
        NSLayoutConstraint.activate(distanceLabelConstraints)
    }
    
    func configure(with title: String, distance: Double?) {
        self.titleLabel.text = title
        guard let distance = distance else { return }
        let distanceRepresentation = String(format:"%.2f", distance)
        self.distanceLabel.text = "현재 위치로부터 약 \(distanceRepresentation)km (직선거리)"
    }
}
