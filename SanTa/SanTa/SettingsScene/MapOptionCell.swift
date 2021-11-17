//
//  MapOptionCell.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/02.
//

import UIKit

class MapOptionCell: UITableViewCell {
    
    static let identifier = "MapOptionCell"

    private(set) var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.setContentCompressionResistancePriority(.init(rawValue: 800), for: .horizontal)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private var map: UILabel = {
        let label = PaddingLabel()
        label.padding(top: 5, bottom: 5, left: 10, right: 10)
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .white
        label.backgroundColor = UIColor(named: "SantaColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.layer.cornerRadius = 5
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.setContentCompressionResistancePriority(.init(rawValue: 1000), for: .horizontal)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.title, self.map])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        self.contentView.addSubview(self.stackView)
        let locationConstrain = [
            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15),
            self.stackView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 30),
            self.stackView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -30),
        ]
        NSLayoutConstraint.activate(locationConstrain)
    }
    
    func update(option: MapOption) {
        self.title.text = option.text
        self.map.text = option.map.name
    }
}

// MARK: - Accessibility

extension MapOptionCell {
    func configureAccessibility() {
        self.configureDynamicTypeAccessibility()
        self.configureVoiceOverAccessibility()
    }
    
    private func configureDynamicTypeAccessibility() {
        self.stackView.axis =
        self.traitCollection.preferredContentSizeCategory < .accessibilityLarge ?
            .horizontal : .vertical
    }
    
    private func configureVoiceOverAccessibility() {
        self.map.isAccessibilityElement = false
        self.accessibilityLabel = "\(title.text ?? "")"
        self.accessibilityValue = "\(map.text ?? "")"
        self.accessibilityHint = "지도형식을 바꾸려면 이중탭 하십시오"
        self.accessibilityIdentifier = "\(title.text ?? "") Cell"
    }
}
