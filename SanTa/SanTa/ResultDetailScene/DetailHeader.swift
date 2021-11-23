//
//  DetailHeader.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/22.
//

import UIKit

class DetailHeader: UICollectionReusableView {
    static let identifier = "DetailHeader"
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBackground
        label.backgroundColor = .label
        label.textAlignment = .center
        label.text = "2021. 11. 16(화)"
        label.font = .preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var startLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "SantaColor")
        label.text = "시작"
        label.textAlignment = .right
        label.font = .preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var endLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "SantaColor")
        label.text = "종료"
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var startTime: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "오후 6시 0분"
        label.textAlignment = .right
        label.numberOfLines = 2
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var endTime: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "오후 7시 38분"
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 20
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 20
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    private func configure() {
        self.configureStackView()
        self.configureViews()
    }
    
    private func configureViews() {
        self.addSubview(self.dateLabel)
        self.addSubview(self.labelStackView)
        self.addSubview(self.timeStackView)
        
        NSLayoutConstraint.activate([
            self.dateLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.dateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            self.labelStackView.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 20),
            self.labelStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.labelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.labelStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            self.timeStackView.topAnchor.constraint(equalTo: self.labelStackView.bottomAnchor, constant: 8),
            self.timeStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.timeStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.timeStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    private func configureStackView() {
        [self.startLabel, self.endLabel].forEach { self.labelStackView.addArrangedSubview($0) }
        [self.startTime, self.endTime].forEach { self.timeStackView.addArrangedSubview($0) }
    }
}
