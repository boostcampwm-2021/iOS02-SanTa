//
//  DetailHeader.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/22.
//

import UIKit

class DetailHeader: UICollectionReusableView {
    static let identifier = "DetailHeader"
    
    private lazy var dateLabel: PaddingLabel = {
        let label = PaddingLabel(insets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        label.backgroundColor = .label
        label.textColor = .systemBackground
        label.text = "2021. 11. 16(화)"
        label.font = .preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var startLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "SanTaColor")
        label.text = "시작"
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var endLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "SanTaColor")
        label.text = "종료"
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var startTime: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "오후 6시 0분"
        label.font = .preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var endTime: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "오후 7시 38분"
        label.font = .preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fill
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
            self.dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            self.dateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            self.labelStackView.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 20),
            self.labelStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            self.timeStackView.topAnchor.constraint(equalTo: self.labelStackView.bottomAnchor, constant: 20),
            self.timeStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    private func configureStackView() {
        [self.startLabel, self.endLabel].forEach { self.labelStackView.addArrangedSubview($0) }
        [self.startTime, self.endTime].forEach { self.timeStackView.addArrangedSubview($0) }
    }
}
