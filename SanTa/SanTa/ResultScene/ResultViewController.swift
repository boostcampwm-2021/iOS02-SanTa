//
//  ResultViewController.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import UIKit

class ResultViewController: UIViewController {
    weak var coordinator: ResultViewCoordinator?
    private var collectionView: UICollectionView?
    private var viewModel: ResultViewModel?
    
    convenience init(viewModel: ResultViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.viewModel?.viewWillAppear() { [weak self] in
            DispatchQueue.main.async {
                self?.navigationController?.navigationBar.topItem?.title = self?.viewModel?.totalDistance
                self?.collectionView?.reloadData()
            }
        }
    }
    
    private func configureCollectionView() {
        self.collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: self.createCompositionalLayout())
        guard let collectionView = self.collectionView else { return }
        view.addSubview(collectionView)
        collectionView.register(TotalRecordsViewCell.self, forCellWithReuseIdentifier: TotalRecordsViewCell.identifier)
        collectionView.register(RecordsViewCell.self, forCellWithReuseIdentifier: RecordsViewCell.identifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            switch sectionNumber {
            case 0: return self.firstLayoutSection()
            default: return self.secondLayoutSection()
            }
        }
    }

    private func firstLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.35))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func secondLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 3, leading: 10, bottom: 13, trailing: 10)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.16))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.06))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        header.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [header]
        return section
    }
}

extension ResultViewController:  UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let viewModel = self.viewModel else { return 0}
        return viewModel.totalSections + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        default : return self.viewModel?.itemsInSection(section: section - 1) ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TotalRecordsViewCell.identifier,
                for: indexPath
            ) as? TotalRecordsViewCell,
                  let totalInfo = self.viewModel?.totalInfo()
            else { return UICollectionViewCell() }
            cell.configure(distance: totalInfo.distance, count: totalInfo.count, time: totalInfo.time, steps: totalInfo.steps)
            cell.configureVoiceOverAccessibility()
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecordsViewCell.identifier,
                for: indexPath
            ) as? RecordsViewCell,
                  let cellInfo = self.viewModel?.cellInfo(indexPath: IndexPath(item: indexPath.item, section: indexPath.section - 1))
            else { return UICollectionViewCell() }
            cell.layer.cornerRadius = 10
            cell.backgroundColor = .white
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowRadius = 2
            cell.layer.shadowOpacity = 0.8
            cell.layer.shadowOffset = CGSize(width: 0, height: 0.5)
            cell.configure(date: cellInfo.date, title: cellInfo.title, distance: cellInfo.distance, time: cellInfo.time, altitude: cellInfo.altitudeDifference, steps: cellInfo.steps)
            cell.configureVoiceOverAccessibility()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as? SectionHeaderView,
              let sectionInfo = self.viewModel?.sectionInfo(section: indexPath.section - 1)
        else { return UICollectionReusableView() }
        sectionHeader.configure(month: sectionInfo.date,
                                count: sectionInfo.count,
                                distance: sectionInfo.distance,
                                time: sectionInfo.time)
        sectionHeader.configureVoiceOverAccessibility(date: sectionInfo.accessibiltyDate)
        return sectionHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexPath = IndexPath(item: indexPath.item, section: indexPath.section - 1)
        guard indexPath.section >= 0,
              let records = self.viewModel?.selectedRecords(indexPath: indexPath) else { return }
        self.coordinator?.presentResultDetailViewController(records: records)
    }
}

extension ResultViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        let navigationBarChangePointY = 100.0
        if scrollView.contentOffset.y > navigationBarChangePointY {
            if navigationBar.isHidden {
                navigationBar.isHidden = false
                self.view.setNeedsLayout()
            }
            navigationBar.layer.opacity = Float(0.05 * (scrollView.contentOffset.y - navigationBarChangePointY))
        } else {
            if !navigationBar.isHidden {
                navigationBar.isHidden = true
                self.view.setNeedsLayout()
            }
        }
    }
}
