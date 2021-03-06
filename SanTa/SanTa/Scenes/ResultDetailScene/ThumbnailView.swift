//
//  ThumbnailView.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/24.
//

import UIKit
import MapKit

final class ThumbnailView: MKAnnotationView {
    static let ReuseID = "ThumbnailAnnotation"

    private lazy var displayView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 2
        return view
    }()

    private lazy var imageView = UIImageView()
    private(set) var imageIdentifier = String()

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        self.frame = CGRect(x: 0, y: 0, width: 38, height: 38)
        self.configure()
    }

    private func configure() {
        displayView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(displayView)
        self.addSubview(imageView)

        NSLayoutConstraint.activate([
            self.displayView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.displayView.topAnchor.constraint(equalTo: self.topAnchor),
            self.displayView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.displayView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            self.imageView.leftAnchor.constraint(equalTo: self.displayView.leftAnchor, constant: 2),
            self.imageView.topAnchor.constraint(equalTo: self.displayView.topAnchor, constant: 2),
            self.imageView.rightAnchor.constraint(equalTo: self.displayView.rightAnchor, constant: -2),
            self.imageView.bottomAnchor.constraint(equalTo: self.displayView.bottomAnchor, constant: -2)
        ])
    }

    func configureImage(uiImage: UIImage, id: String) {
        self.imageView.image = uiImage
        self.imageIdentifier = id
    }
}
