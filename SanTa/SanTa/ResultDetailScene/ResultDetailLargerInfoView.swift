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

    typealias DetailLargerInfoDataSource = UICollectionViewDiffableDataSource<DetailLargerInfoSection, AnyHashable>
    typealias DetailLargerInfoSnapshot = NSDiffableDataSourceSnapshot<DetailLargerInfoSection, AnyHashable>

    private var dataSource: DetailLargerInfoDataSource?
    private var currentSnapshot: DetailLargerInfoSnapshot?

    private var date: String = ""
    private var startTime: String = ""
    private var endTime: String = ""

    lazy var collectionView: UICollectionView = {
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
        NSLayoutConstraint.activate([
            upDownView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            upDownView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            upDownView.heightAnchor.constraint(equalToConstant: 4),
            upDownView.widthAnchor.constraint(equalToConstant: self.frame.width/3)
        ])
    }

    func configure() {
        self.configureCollectionView()
        self.configureViews()
        self.configuareDataSource()
        self.displayUpDownMark()
    }

    func configureHeaderInformation(date: String, startTime: String, endTime: String) {
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
    }

    func bindSnapShotApply(section: DetailLargerInfoSection, item: [AnyHashable]) {
        var snapshot = DetailLargerInfoSnapshot()
        snapshot.appendSections([.main])
        item.forEach {
            snapshot.appendItems([$0], toSection: section)
        }
        self.dataSource?.apply(snapshot, animatingDifferences: true)
        self.currentSnapshot = snapshot
        self.configureHeader()
    }

    private func configureViews() {
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.backgroundColor = .systemBackground
        self.addSubview(self.collectionView)

        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    private func configuareDataSource() {
        let datasource = DetailLargerInfoDataSource(collectionView: self.collectionView,
                                                     cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell in

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCell.identifier, for: indexPath) as? DetailCell,
                let item = item as? DetailInformationModel else {
                return UICollectionViewCell() }
            cell.layout(data: item)
            cell.configureVoiceOverAccessibility()
            return cell
        })

        self.dataSource = datasource
        self.collectionView.dataSource = dataSource
    }

    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = configureCompositionalLayout()
        self.collectionView.register(DetailCell.self, forCellWithReuseIdentifier: DetailCell.identifier)
        self.collectionView.register(DetailHeader.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: DetailHeader.identifier)
    }

    private func configureHeader() {
        self.dataSource?.supplementaryViewProvider = { (
            collectionView: UICollectionView,
            _: String,
            indexPath: IndexPath) -> UICollectionReusableView? in
            guard let header: DetailHeader = self.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailHeader.identifier, for: indexPath) as? DetailHeader else { return DetailHeader() }

            header.configure(date: self.date, startTime: self.startTime, endTime: self.endTime)
            header.configureVoiceOverAccessibility()
            return header
        }
    }

    private func configureCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.495), heightDimension: .estimated(500)))
            item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .none
            section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(200))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)

            section.boundarySupplementaryItems = [sectionHeader]
            return section
        }
    }
}
