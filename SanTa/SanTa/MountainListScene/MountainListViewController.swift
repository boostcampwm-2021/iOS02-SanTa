//
//  MountainListViewController.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import UIKit
import Combine
import CoreLocation

final class MountainListViewController: UIViewController {
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
        self.configureCollectionView()
        self.configureView()
        self.configuareDataSource()
        self.configureBinding()
        self.viewModel?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureSearchBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.searchController = nil
        self.view.setNeedsLayout()
    }

    private func configureSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색"
        searchController.searchResultsUpdater = self

        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func bindSnapShotApply(section: MountainListSection, item: [AnyHashable]) {
        DispatchQueue.main.async { [weak self] in
            var snapshot = MountainListSnapshot()
            snapshot.appendSections([.main])
            item.forEach {
                snapshot.appendItems([$0], toSection: section)
            }
            self?.dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }

    private func configureBinding() {
        self.viewModel?.$mountains
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] mountains in
                guard let mountains = mountains else { return }
                self?.bindSnapShotApply(section: MountainListSection.main, item: mountains)
            })
            .store(in: &self.subscriptions)

        self.viewModel?.$mountainName
            .debounce(for: 0.7, scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.viewModel?.findMountains()
            }
            .store(in: &subscriptions)
    }

    private func configureCollectionView() {
        self.mountainListCollectionView.delegate = self
        self.mountainListCollectionView.collectionViewLayout = configureCompositionalLayout()
        self.mountainListCollectionView.register(MountainCell.self, forCellWithReuseIdentifier: MountainCell.identifier)
    }

    private func configureView() {
        self.view.addSubview(self.mountainListCollectionView)
        NSLayoutConstraint.activate([
            self.mountainListCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.mountainListCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.mountainListCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.mountainListCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }

    private func configureCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500)))
            item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .none
            section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

            return section
        }
    }

    private func configuareDataSource() {
        let datasource = MountainListDataSource(collectionView: self.mountainListCollectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell in

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MountainCell.identifier, for: indexPath) as? MountainCell else {
                return UICollectionViewCell() }
            guard let item = item as? MountainEntity else { return cell }
            cell.update(mountain: item)
            cell.configureVoiceOverAccessibility()
            return cell
        })

        self.dataSource = datasource
        self.mountainListCollectionView.dataSource = dataSource
    }
}

extension MountainListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let mountains = self.viewModel?.mountains else { return }
        self.coordinator?.pushMountainDetailViewController(mountainAnnotation: MountainAnnotation(
            title: mountains[indexPath.item].mountain.mountainName,
            subtitle: mountains[indexPath.item].mountain.mountainHeight + "m",
            latitude: mountains[indexPath.item].latitude,
            longitude: mountains[indexPath.item].longitude,
            mountainDescription: mountains[indexPath.item].mountain.mountainShortDescription,
            region: mountains[indexPath.item].mountain.mountainRegion))
    }
}

extension MountainListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mountainName = searchController.searchBar.text else { return }
        self.viewModel?.mountainName = mountainName
    }
}
