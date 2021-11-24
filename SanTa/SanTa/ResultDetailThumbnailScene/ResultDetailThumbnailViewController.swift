//
//  ResultDetailThumbnailViewController.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/24.
//

import UIKit

class ResultDetailThumbnailViewController: UIViewController {
    weak var coordinator: ResultDetailThumbnailViewCoordinator?
    
    enum DetailThumbnailSection: Int, CaseIterable {
        case main
    }
    
    typealias DetailThumbnailDataSource = UICollectionViewDiffableDataSource<DetailThumbnailSection, AnyHashable>
    typealias DetailThumbnailSnapshot = NSDiffableDataSourceSnapshot<DetailThumbnailSection, AnyHashable>
    
    private var dataSource: DetailThumbnailDataSource?
    
    var uiImages = [String: UIImage]()
    var currentIdentifier = String()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .init(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.configureViews()
        self.configuareDataSource()
        self.configureImages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.coordinator?.dismiss()
    }
    
    private func configureViews() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.heightAnchor.constraint(equalTo: self.view.widthAnchor),
            self.collectionView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = configureCompositionalLayout()
        self.collectionView.register(DetailImagesCell.self, forCellWithReuseIdentifier: DetailImagesCell.identifier)
    }
    
    private func bindSnapShotApply(section: DetailThumbnailSection, item: [AnyHashable]) {
        var snapshot = DetailThumbnailSnapshot()
        snapshot.appendSections([.main])
        item.forEach {
            snapshot.appendItems([$0], toSection: section)
        }
        self.dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func configureCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)))
            item.contentInsets = .init(top: 3, leading: 3, bottom: 3, trailing: 3)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .paging
            section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
            return section
        }
    }
    
    private func configuareDataSource() {
        let datasource = DetailThumbnailDataSource(collectionView: self.collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailImagesCell.identifier, for: indexPath) as? DetailImagesCell,
                  let item = item as? String,
                  let image = self.uiImages[item] else  {
                return UICollectionViewCell() }
            
            cell.update(image: image)
            return cell
        })
        
        self.dataSource = datasource
        self.collectionView.dataSource = dataSource
    }
    
    private func configureImages() {
        var identifiers = [String]()
        
        for (key, _) in self.uiImages {
            identifiers.append(key)
        }
        
        self.bindSnapShotApply(section: .main, item: identifiers)
    }
}
