//
//  CollectionViewCell.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/16.
//

import UIKit

class DetailCell: UICollectionViewCell {
    private let title: UILabel = UILabel()
    
    func layout(data: ResultDetailCellRepresentable) {
        self.title.text = data.title
        self.title.textColor = .init(named: "SantaColor")
        
        self.title.translatesAutoresizingMaskIntoConstraints = false
        let titleConstraints = [
            self.title.topAnchor.constraint(equalTo: self.topAnchor),
            self.title.leftAnchor.constraint(equalTo: self.leftAnchor)
        ]
        NSLayoutConstraint.activate(titleConstraints)
        
        var contentLabels: [UILabel] = []
        var contentTitleLabels: [UILabel] = []
        
        for content in data.contents {
            let contentLabel = UILabel()
            contentLabel.text = content.content
            let contentTitleLabel = UILabel()
            contentTitleLabel.text = content.contentTitle
            contentLabels.append(contentLabel)
            contentTitleLabels.append(contentTitleLabel)
        }
        
        let stack = UIStackView()
        stack.axis = .vertical
        
        for index in 0..<data.contents.count {
            let horizontalStack = UIStackView()
            horizontalStack.axis = .horizontal
            horizontalStack.addArrangedSubview(contentLabels[index])
            horizontalStack.addArrangedSubview(contentTitleLabels[index])
            stack.addArrangedSubview(horizontalStack)
        }
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        let stackConstraint = [
            stack.topAnchor.constraint(equalTo: self.title.bottomAnchor),
            stack.leftAnchor.constraint(equalTo: self.leftAnchor),
            stack.rightAnchor.constraint(equalTo: self.rightAnchor),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(stackConstraint)
    }
}

extension DetailCell {
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.lineWidth = 1
        path.lineJoinStyle = .round
        let startingX: CGFloat = title.frame.origin.x + title.frame.width
        let startingY: CGFloat = title.frame.origin.y + title.frame.height / 2
        path.move(to: CGPoint(x: startingX, y: startingY))
        path.addLine(to: CGPoint(x: self.bounds.width, y: startingY))
        path.close()
        UIColor(named: "SantaColor")?.set()
        path.stroke()
    }
}
