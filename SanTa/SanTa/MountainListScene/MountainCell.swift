//
//  MountainCell.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/01.
//

import UIKit

final class MountainCell: UICollectionViewCell {
    
    static let identifier = "MountainCell"
    
    private var name: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private var height: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .systemGray2
        return label
    }()
    
    private var location: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .callout)
        label.numberOfLines = 5
        label.textColor = .systemGray2
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.name, self.height])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        self.addSubview(self.stackView)
        let stackViewConstrain = [
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            self.stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30),
        ]
        NSLayoutConstraint.activate(stackViewConstrain)
        
        self.addSubview(self.location)
        let locationConstrain = [
            self.location.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 10),
            self.location.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30),
            self.location.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            self.location.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
        ]
        NSLayoutConstraint.activate(locationConstrain)
    }
    
    func update(mountain: MountainEntity) {
        self.name.text = mountain.mountain.mountainName
        self.height.text = mountain.mountain.mountainHeight + " m"
        self.location.text = mountain.mountain.mountainRegion
    }
}

// MARK: - Accessibility

extension MountainCell {
    func configureVoiceOverAccessibility() {
        guard let name = name.text else { return }
        guard let height = height.text else { return }
        guard let location = location.text else { return }
        self.isAccessibilityElement = true
        self.accessibilityLabel = "\(name) \(height) \(location)"
        self.accessibilityTraits = .button
        self.accessibilityHint = "상세화면으로 이동하려면 이중탭 하십시오"
        self.accessibilityIdentifier = "\(name) \(height) \(location) Cell"
    }
}
