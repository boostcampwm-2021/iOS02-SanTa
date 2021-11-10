//
//  MountainDetailTableViewCell.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/09.
//

import UIKit

class MountainDetailTableViewCell: UITableViewCell {
    static let identifier = "MountainDetailTableViewCellID"
    
    let categoryLabel = UILabel()
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
        categoryLabel.backgroundColor = .green
        categoryLabel.textColor = .white
        
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byCharWrapping
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(categoryLabel)
        self.addSubview(contentLabel)
        
        let categoryLabelConstraints = [
            categoryLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            categoryLabel.topAnchor.constraint(equalTo: self.topAnchor, constant:  20)
        ]
        NSLayoutConstraint.activate(categoryLabelConstraints)
        
        let contentLabelConstraints = [
            contentLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            contentLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            contentLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10),
            contentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(contentLabelConstraints)
    }
    
    func configure(category: String, content: String) {
        categoryLabel.text = category
        contentLabel.text = content
    }
}
