//
//  MountainListViewController.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import UIKit
import Combine

class MountainListViewController: UIViewController {
    enum MountainListSection: Int, CaseIterable {
        case main
    }
    
    typealias MountainListDataSource = UICollectionViewDiffableDataSource<MountainListSection, AnyHashable>
    typealias MountainListSnapshot = NSDiffableDataSourceSnapshot<MountainListSection, AnyHashable>
    
    weak var coordinator: MountainListViewCoordinator?
    
    var dataSource: MountainListDataSource?
    
    private var viewModel: MountainListViewModel?
    private var subscriptions = Set<AnyCancellable>()
    
    let mountainListCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .init(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()
    
    convenience init(viewModel: MountainListViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSearchBar()
        self.configureCollectionView()
        self.configureView()
        self.configuareDataSource()
        self.configureData()
        self.configureBinding()
        self.viewModel?.viewDidLoad()
    }
    
    private func configureSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색"
        self.navigationItem.searchController = searchController
    }
    
    private func bindSnapShotApply(section: MountainListSection, item: [AnyHashable]) {
        DispatchQueue.global().sync {
            guard var snapshot = dataSource?.snapshot() else { return }
            item.forEach {
                snapshot.appendItems([$0], toSection: section)
            }
            dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private func configureBinding() {
        self.viewModel?.$mountains
            .receive(on: DispatchQueue.main)
            .sink (receiveValue: { [weak self] mountains in
                guard let mountains = mountains else { return }
                self?.bindSnapShotApply(section: MountainListSection.main, item: mountains)
            })
            .store(in: &self.subscriptions)
    }
    
    private func configureCollectionView() {
        self.mountainListCollectionView.delegate = self
        self.mountainListCollectionView.collectionViewLayout = configureCompositionalLayout()
        self.mountainListCollectionView.register(MountainCell.self, forCellWithReuseIdentifier: MountainCell.identifier)
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
    
    private func configuareDataSource() {
        let datasource = MountainListDataSource (collectionView: self.mountainListCollectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MountainCell.identifier, for: indexPath) as? MountainCell else  {
                return UICollectionViewCell() }
            guard let item = item as? MountainEntity else { return cell }
            cell.update(mountain: item)
            return cell
        })
        
        self.dataSource = datasource
        self.mountainListCollectionView.dataSource = dataSource
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
