//
//  DetailInfoView.swift
//  SwipeView
//
//  Created by Jiwon Yoon on 2021/11/11.
//

import UIKit

class ResultDetailLargerInfoView: UIView {
    enum DetailLargerInfoSection: Int, CaseIterable {
        case main
    }
    
    typealias DetailLargerInfoDataSource = UICollectionViewDiffableDataSource<ResultDetailLargerInfoView, AnyHashable>
    typealias DetailLargerInfoSnapshot = NSDiffableDataSourceSnapshot<ResultDetailLargerInfoView, AnyHashable>
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .init(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
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
    
    func configure() {
        self.configureCollectionView()
        self.configureViews()
        self.displayUpDownMark()
    }
    
    private func configureViews() {
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 5),
            self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        self.layoutIfNeeded()
    }
    
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = configureCompositionalLayout()
        self.collectionView.register(DetailCell.self, forCellWithReuseIdentifier: DetailCell.identifier)
    }
    
    private func configureCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(500)))
            item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .none
            section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            return section
        }
    }
}
