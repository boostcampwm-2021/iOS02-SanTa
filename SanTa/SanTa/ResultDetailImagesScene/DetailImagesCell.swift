//
//  DetailImagesCell.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/24.
//

import UIKit

class DetailImagesCell: UICollectionViewCell {
    static let identifier = "DetailImagesCell"
    
    private let imageView = UIImageView()
    
    func update(image: UIImage) {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        
        self.imageView.image = image
        
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
