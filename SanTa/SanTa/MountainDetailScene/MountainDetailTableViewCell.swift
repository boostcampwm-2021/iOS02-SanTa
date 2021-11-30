//
//  MountainDetailTableViewCell.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/09.
//

import UIKit

class MountainDetailTableViewCell: UITableViewCell {
    static let identifier = "MountainDetailTableViewCellID"

    let categoryLabel = PaddingLabel(insets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
    let contentLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLayout() {
        self.categoryLabel.backgroundColor = .init(named: "SantaColor")
        self.categoryLabel.textColor = .white
        self.categoryLabel.clipsToBounds = true
        self.categoryLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        self.categoryLabel.layer.cornerRadius = 5

        self.contentLabel.numberOfLines = 0
        self.contentLabel.lineBreakMode = .byCharWrapping
        self.contentLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)

        self.categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentLabel.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(self.categoryLabel)
        self.addSubview(self.contentLabel)

        NSLayoutConstraint.activate([
            self.categoryLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25),
            self.categoryLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20)
        ])

        NSLayoutConstraint.activate([
            self.contentLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25),
            self.contentLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            self.contentLabel.topAnchor.constraint(equalTo: self.categoryLabel.bottomAnchor, constant: 10),
            self.contentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    func configure(category: String, content: String) {
        self.categoryLabel.isHidden = content.isEmpty
        self.categoryLabel.text = category
        self.contentLabel.text = content
    }
}
