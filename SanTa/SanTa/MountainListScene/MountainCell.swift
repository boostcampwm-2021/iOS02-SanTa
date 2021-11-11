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
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private var height: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .systemGray2
        return label
    }()
    
    private var location: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
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
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30),
        ]
        NSLayoutConstraint.activate(stackViewConstrain)
        
        self.addSubview(self.location)
        let locationConstrain = [
            self.location.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 10),
            self.location.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30),
            self.location.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ]
        NSLayoutConstraint.activate(locationConstrain)
    }
    
    func update(mountain: MountainEntity) {
        self.name.text = mountain.mountain.mountainName
        self.height.text = mountain.mountain.mountainHeight + " m"
        self.location.text = mountain.mountain.mountainRegion
    }
}
