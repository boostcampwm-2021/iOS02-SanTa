//
//  CollectionViewCell.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/16.
//

import UIKit

class DetailCell: UICollectionViewCell {
    static let identifier = "DetailCell"
    
    func layout(data: LargeViewModel) {
        let title: UILabel = UILabel()
        self.addSubview(title)
        title.text = data.title
        title.font = .preferredFont(for: .body, weight: .bold)
        title.numberOfLines = 0
        title.adjustsFontSizeToFitWidth = true
        title.textColor = .init(named: "SantaColor")
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10)
        ])
        
        let line = UIView()
        self.addSubview(line)
        
        line.backgroundColor = .init(named: "SantaColor")
        line.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            line.heightAnchor.constraint(equalToConstant: 1),
            line.leftAnchor.constraint(equalTo: title.rightAnchor, constant: 5),
            line.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            line.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15),
        ])
        
        
        
        var contentLabels: [UILabel] = []
        var contentTitleLabels: [UILabel] = []
        
        for content in data.contents {
            let contentLabel = UILabel()
            contentLabel.text = content.content
            contentLabel.font = .preferredFont(for: .title1, weight: .bold)
            contentLabel.numberOfLines = 0

            let contentTitleLabel = UILabel()
            contentTitleLabel.text = content.contentTitle
            contentTitleLabel.font = .preferredFont(forTextStyle: .body)
            contentTitleLabel.numberOfLines = 0
            contentLabels.append(contentLabel)
            contentTitleLabels.append(contentTitleLabel)
        }
        
        let stack = UIStackView()
        self.addSubview(stack)
        stack.axis = .vertical
        
        for index in 0..<data.contents.count {
            let horizontalStack = UIStackView()
            horizontalStack.axis = .horizontal
            horizontalStack.distribution = .equalCentering
            horizontalStack.addArrangedSubview(contentLabels[index])
            horizontalStack.addArrangedSubview(contentTitleLabels[index])
            stack.addArrangedSubview(horizontalStack)
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
//extension DetailCell {
//    override func draw(_ rect: CGRect) {
//        let path = UIBezierPath()
//        path.lineWidth = 1
//        path.lineJoinStyle = .round
//        let startingX: CGFloat = title.frame.origin.x + title.frame.width
//        let startingY: CGFloat = title.frame.origin.y + title.frame.height / 2
//        path.move(to: CGPoint(x: startingX, y: startingY))
//        path.addLine(to: CGPoint(x: self.bounds.width, y: startingY))
//        path.close()
//        UIColor(named: "SantaColor")?.set()
//        path.stroke()
//    }
//}
