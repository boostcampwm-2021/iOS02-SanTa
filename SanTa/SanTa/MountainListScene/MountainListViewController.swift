//
//  MountainListViewController.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import UIKit

class MountainListViewController: UIViewController {
    enum MountainListSection: Int, CaseIterable {
        case main
    }
    
    typealias MountainListDataSource = UICollectionViewDiffableDataSource<MountainListSection, AnyHashable>
    typealias MountainListSnapshot = NSDiffableDataSourceSnapshot<MountainListSection, AnyHashable>
    
    weak var coordinator: MountainListViewCoordinator?
    
    var dataSource: MountainListDataSource?
    
    let mountainListCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .init(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.configureView()
        self.configureData()
    }
    
    private func configureCollectionView() {
        self.mountainListCollectionView.delegate = self
        self.mountainListCollectionView.collectionViewLayout = configureCompositionalLayout()
    }
    
    private func configureView() {
        self.view.addSubview(self.mountainListCollectionView)
        let collectionViewConstrain = [
            self.mountainListCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.mountainListCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.mountainListCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.mountainListCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
        ]
        NSLayoutConstraint.activate(collectionViewConstrain)
    }
    
    private func configureCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.25)))
            item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(180)),subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .none
            section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
            return section
        }
    }
    
    private func configureData() {
        var snapshot = MountainListSnapshot()
        MountainListSection.allCases.forEach {
            snapshot.appendSections([$0])
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

extension MountainListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


struct Mountain {
    let name: String
    let height: String
    let location: String
}

let dummy = [Mountain(name: "백두산", height: "1000m", location: "북한"),
             Mountain(name: "한라산", height: "2000m", location: "제주도")]
