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
    }
    
    private func configureCollectionView() {
        self.mountainListCollectionView.delegate = self
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
