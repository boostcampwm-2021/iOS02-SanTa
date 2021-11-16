//
//  DetailInfoView.swift
//  SwipeView
//
//  Created by Jiwon Yoon on 2021/11/11.
//

import UIKit

class ResultDetailLargerInfoView: UIView {
    private var collectionView: UICollectionView

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.collectionView = UICollectionView(frame: frame)
        self.backgroundColor = .green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ResultDetailLargerInfoView {
    private func configureDownArrow() {
        //chevron.compact.down
        let downArrow:UIImageView = .init(image: UIImage(systemName: "chevron.compact.down")?.withTintColor(.black))
        downArrow.translatesAutoresizingMaskIntoConstraints = false
        let downArrowConstraints = [
            downArrow.topAnchor.constraint(equalTo: self.topAnchor),
            downArrow.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ]
        NSLayoutConstraint.activate(downArrowConstraints)
    }
    
    private func configure(collectionView: UICollectionView) {
        self.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
    }
}

extension ResultDetailLargerInfoView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}
