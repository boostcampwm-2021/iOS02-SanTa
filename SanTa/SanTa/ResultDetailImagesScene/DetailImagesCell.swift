//
//  DetailImagesCell.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/24.
//

import UIKit

final class DetailImagesCell: UICollectionViewCell {
    static let identifier = "DetailImagesCell"

    private let imageView = UIImageView()
    var id = String()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)

        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    func update(image: UIImage, id: String) {
        self.imageView.image = image
        self.id = id
    }
}
