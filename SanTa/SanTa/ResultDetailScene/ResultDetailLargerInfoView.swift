//
//  DetailInfoView.swift
//  SwipeView
//
//  Created by Jiwon Yoon on 2021/11/11.
//

import UIKit

class ResultDetailLargerInfoView: UIView {
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .init(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ResultDetailLargerInfoView {
    private func displayUpDownMark() {
        let upDownView = UIView()
        upDownView.backgroundColor = .label
        upDownView.translatesAutoresizingMaskIntoConstraints = false
        upDownView.layer.cornerRadius = 2
        upDownView.layer.masksToBounds = true
        
        self.addSubview(upDownView)
        let upDownConstraints = [
            upDownView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            upDownView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            upDownView.heightAnchor.constraint(equalToConstant: 4),
            upDownView.widthAnchor.constraint(equalToConstant: self.frame.width/2)
        ]
        NSLayoutConstraint.activate(upDownConstraints)
    }
    
    private func configure(collectionView: UICollectionView) {
        self.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            collectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension ResultDetailLargerInfoView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        section == 0 ? 3 : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
