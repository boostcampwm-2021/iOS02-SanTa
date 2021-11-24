//
//  CollectionViewCell.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/16.
//

import UIKit

class DetailCell: UICollectionViewCell {
    static let identifier = "DetailCell"
    
    let title: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(for: .body, weight: .bold)
        label.textColor = .init(named: "SantaColor")
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    let line: UIView = {
        let view = UIView()
        view.backgroundColor = .init(named: "SantaColor")
        
        return view
    }()
    
    let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        
        return stack
    }()
    
    func layout(data: LargeViewModel) {
        self.addSubview(title)
        title.text = data.title
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10)
        ])
        
        self.addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            line.heightAnchor.constraint(equalToConstant: 1),
            line.leftAnchor.constraint(equalTo: title.rightAnchor, constant: 5),
            line.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            line.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15),
        ])
        
        stack.subviews.forEach{ $0.removeFromSuperview() }
        self.addSubview(stack)
        for content in data.contents {
            stack.addArrangedSubview(UIStackView(content: content))
        }
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 30),
            stack.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            stack.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

extension UIFont {
    static func preferredFont(for style: TextStyle, weight: Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
        return metrics.scaledFont(for: font)
    }
}

extension UIStackView {
    convenience init(content: CellContentEntity) {
        self.init()
        self.axis = .horizontal
        self.distribution = .equalCentering
        
        let contentLabel = UILabel()
        contentLabel.text = content.content
        contentLabel.font = .preferredFont(for: .title1, weight: .bold)
        contentLabel.numberOfLines = 0

        let contentTitleLabel = UILabel()
        contentTitleLabel.text = content.contentTitle
        contentTitleLabel.font = .preferredFont(forTextStyle: .body)
        contentTitleLabel.numberOfLines = 0
        
        self.addArrangedSubview(contentLabel)
        self.addArrangedSubview(contentTitleLabel)
    }
}
