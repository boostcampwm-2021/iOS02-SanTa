//
//  ResultDetailImagesViewController.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/23.
//

import UIKit

class ResultDetailImagesViewController: UIViewController {
    weak var coordinator: ResultDetailImagesViewCoordinator?
    
    enum DetailImagesSection: Int, CaseIterable {
        case main
    }
    
    typealias DetailImagesDataSource = UICollectionViewDiffableDataSource<DetailImagesSection, AnyHashable>
    typealias DetailImagesSnapshot = NSDiffableDataSourceSnapshot<DetailImagesSection, AnyHashable>
    
    private var dataSource: DetailImagesDataSource?
    
    var uiImages = [String: UIImage]()
    var identifiers = [String]()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.coordinator?.dismiss()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func configureViews() {
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.tintColor = .label
        self.title = "사진 모아보기 (\(uiImages.count)장)"
        self.view.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func configureCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.collectionViewLayout = configureCompositionalLayout()
        self.collectionView.register(DetailImagesCell.self, forCellWithReuseIdentifier: DetailImagesCell.identifier)
    }
    
    private func bindSnapShotApply(section: DetailImagesSection, item: [AnyHashable]) {
        var snapshot = DetailImagesSnapshot()
        snapshot.appendSections([.main])
        item.forEach {
            snapshot.appendItems([$0], toSection: section)
        }
        self.dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func configureCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalWidth(1/3)))
            item.contentInsets = .init(top: 3, leading: 3, bottom: 3, trailing: 3)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/3)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .none
            section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
            return section
        }
    }
    
    private func configuareDataSource() {
        let datasource = DetailImagesDataSource(collectionView: self.collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailImagesCell.identifier, for: indexPath) as? DetailImagesCell,
                  let item = item as? String,
                  let image = self.uiImages[item] else  {
                return UICollectionViewCell() }
            
            cell.update(image: image, id: item)
            return cell
        })
        
        self.dataSource = datasource
        self.collectionView.dataSource = dataSource
    }
    
    private func configureImages() {
        for (key, _) in self.uiImages {
            self.identifiers.append(key)
        }
        
        self.bindSnapShotApply(section: .main, item: self.identifiers)
    }
}

extension ResultDetailImagesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt index: IndexPath) {
        self.coordinator?.presentResultDetailThumbnailViewController(uiImages: self.uiImages, id: self.identifiers[index.item])
    }
}
