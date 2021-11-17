//
//  CollectionViewCell.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/16.
//

import UIKit

class DetailCell: UICollectionViewCell {
    var data: ResultDetailCellRepresentable?
    let title: UILabel = UILabel()
    
    func configure(with cellData: ResultDetailCellRepresentable) {
        self.data = cellData
        
        
    }
}

extension DetailCell {
    private func layout(data: ResultDetailCellRepresentable) {
        let title = UILabel()
        title.text = data.title
    }
    
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
