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
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .label
        label.textColor = .systemBackground
        label.text = "2021. 11. 16(화)"
        label.font = .preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private lazy var startLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "SanTaColor")
        label.text = "시작"
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private lazy var endLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "SanTaColor")
        label.text = "종료"
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private lazy var startTime: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "오후 6시 0분"
        label.font = .preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private lazy var endTime: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "오후 7시 38분"
        label.font = .preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

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
    
    private func configureViews(collectionView: UICollectionView) {
        self.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            collectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
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
