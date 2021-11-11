//
//  ResultViewController.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import UIKit

struct TopMain {
    let distance = "42.195"
    let count = "1"
    let time = "02:30"
    let steps = "99999"
}

struct HeaderInfo {
    let month = "2021. 11"
    let count = "6회"
    let distance = "31.084"
    let time = "01:45"
}

struct CellInfo {
    let date = "어제(목) 오후 3시 46분"
    let distance = "2.56"
    let time = "03.01"
    let altitude = "20"
    let steps = "512"
}

class TopMainCell: UICollectionViewCell {
    static let identifier = "TopMainCell"
    let kilometerNumber = UILabel()
    let kilometer = UILabel()
    let countNumber = UILabel()
    let count = UILabel()
    let timeNumber = UILabel()
    let time = UILabel()
    let stepsNumber = UILabel()
    let steps = UILabel()
    let horizontalStackView = UIStackView()
    let countVerticalStackView = UIStackView()
    let timeVerticalStackView = UIStackView()
    let stepsVerticalStackView = UIStackView()
    
    func configure(distance: String, count: String, time: String, steps: String) {
        self.configureSubviews()
        self.configureLayout()
        self.kilometerNumber.text = distance
        self.kilometerNumber.font = .systemFont(ofSize: 60)
        self.kilometer.text = "킬로미터"
        self.kilometer.font = .systemFont(ofSize: 15)
        self.countNumber.text = count
        self.countNumber.font = .systemFont(ofSize: 25)
        self.count.text = "횟수"
        self.count.font = .systemFont(ofSize: 15)
        self.timeNumber.text = time
        self.timeNumber.font = .systemFont(ofSize: 25)
        self.time.text = "시간"
        self.time.font = .systemFont(ofSize: 15)
        self.stepsNumber.text = steps
        self.stepsNumber.font = .systemFont(ofSize: 25)
        self.steps.text = "걸음"
        self.steps.font = .systemFont(ofSize: 15)
        self.backgroundColor = .systemGray6
        let border = CALayer()
        border.frame = CGRect.init(x: 0, y: self.frame.height, width: self.frame.width, height: -1)
        border.backgroundColor = UIColor.systemGray4.cgColor
        self.layer.addSublayer(border)
    }
    
    private func configureSubviews() {
        self.addSubview(self.kilometerNumber)
        self.addSubview(self.kilometer)
        self.addSubview(self.horizontalStackView)
        self.horizontalStackView.addArrangedSubview(countVerticalStackView)
        self.horizontalStackView.addArrangedSubview(timeVerticalStackView)
        self.horizontalStackView.addArrangedSubview(stepsVerticalStackView)
        self.horizontalStackView.axis = .horizontal
        self.horizontalStackView.distribution = .fillEqually
        self.countVerticalStackView.axis = .vertical
        self.countVerticalStackView.alignment = .center
        self.countVerticalStackView.spacing = 5
        self.timeVerticalStackView.axis = .vertical
        self.timeVerticalStackView.alignment = .center
        self.timeVerticalStackView.spacing = 5
        self.stepsVerticalStackView.axis = .vertical
        self.stepsVerticalStackView.alignment = .center
        self.stepsVerticalStackView.spacing = 5
        self.countVerticalStackView.addArrangedSubview(countNumber)
        self.countVerticalStackView.addArrangedSubview(count)
        self.timeVerticalStackView.addArrangedSubview(timeNumber)
        self.timeVerticalStackView.addArrangedSubview(time)
        self.stepsVerticalStackView.addArrangedSubview(stepsNumber)
        self.stepsVerticalStackView.addArrangedSubview(steps)
    }
    
    private func configureLayout() {
        self.kilometerNumber.translatesAutoresizingMaskIntoConstraints = false
        self.kilometer.translatesAutoresizingMaskIntoConstraints = false
        self.horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.kilometerNumber.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.kilometerNumber.topAnchor.constraint(equalTo: self.topAnchor, constant: 60),
            self.kilometer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.kilometer.topAnchor.constraint(equalTo: self.kilometerNumber.bottomAnchor, constant: 0),
            self.horizontalStackView.topAnchor.constraint(equalTo: self.kilometer.bottomAnchor, constant: 50),
            self.horizontalStackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.horizontalStackView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.horizontalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30)
        ])
    }
}

class Header: UICollectionReusableView {
    static let identifier = "header"
    let monthLabel = UILabel()
    let countLabel = UILabel()
    let distanceLabel = UILabel()
    let timeLabel = UILabel()
    
    func configure(month: String, count: String, distance: String, time: String){
        self.backgroundColor = .white
        self.monthLabel.text = month
        self.monthLabel.font = .boldSystemFont(ofSize: 17)
        self.countLabel.text = count
        self.countLabel.font = .systemFont(ofSize: 15)
        self.countLabel.textColor = .systemGray
        self.distanceLabel.text = distance
        self.distanceLabel.font = .systemFont(ofSize: 15)
        self.distanceLabel.textColor = .systemGray
        self.timeLabel.text = time
        self.timeLabel.font = .systemFont(ofSize: 15)
        self.timeLabel.textColor = .systemGray
        self.configureSubviews()
        self.configureLayout()
    }
    
    private func configureSubviews(){
        self.addSubview(monthLabel)
        self.addSubview(countLabel)
        self.addSubview(distanceLabel)
        self.addSubview(timeLabel)
        self.monthLabel.translatesAutoresizingMaskIntoConstraints = false
        self.countLabel.translatesAutoresizingMaskIntoConstraints = false
        self.distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            self.monthLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.monthLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            self.timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            self.distanceLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.distanceLabel.rightAnchor.constraint(equalTo: self.timeLabel.leftAnchor, constant: -10),
            self.countLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.countLabel.rightAnchor.constraint(equalTo: self.distanceLabel.leftAnchor, constant: -10)
        ])
    }
}

class MyCollectionViewCell: UICollectionViewCell {
    static let identifier = "MyCollectionViewCell"
    let date = PaddingLabel()
    let horizontalStackView = UIStackView()
    let distanceStackView = UIStackView()
    let distance = UILabel()
    let distanceLabel = UILabel()
    let timeStackView = UIStackView()
    let time = UILabel()
    let timeLabel = UILabel()
    let altitudeStackView = UIStackView()
    let altitude = UILabel()
    let altitudeLabel = UILabel()
    let stepsStackView = UIStackView()
    let steps = UILabel()
    let stepsLabel = UILabel()
    
    func configure(date: String, distance: String, time: String, altitude: String, steps: String) {
        self.date.padding(top: 2, bottom: 2, left: 2, right: 2)
        self.date.text = date
        self.date.backgroundColor = UIColor.init(red: 0.50, green: 0.8, blue: 0.37, alpha: 1)
        self.date.layer.cornerRadius = 3
        self.date.clipsToBounds = true
        self.date.textColor = .white
        self.date.font = .boldSystemFont(ofSize: 13)
        self.distance.text = distance
        self.distance.font = .boldSystemFont(ofSize: 20)
        self.distanceLabel.text = "거리"
        self.time.text = time
        self.time.font = .boldSystemFont(ofSize: 20)
        self.timeLabel.text = "시간"
        self.altitude.text = altitude
        self.altitude.font = .boldSystemFont(ofSize: 20)
        self.altitudeLabel.text = "고도차"
        self.steps.text = steps
        self.steps.font = .boldSystemFont(ofSize: 20)
        self.stepsLabel.text = "걸음"
        self.configureSubviews()
        self.configureLayout()
    }
    
    private func configureSubviews() {
        self.addSubview(date)
        self.addSubview(horizontalStackView)
        self.horizontalStackView.distribution = .fillEqually
        self.horizontalStackView.axis = .horizontal
        self.distanceStackView.axis = .vertical
        self.distanceStackView.alignment = .center
        self.timeStackView.axis = .vertical
        self.timeStackView.alignment = .center
        self.altitudeStackView.axis = .vertical
        self.altitudeStackView.alignment = .center
        self.stepsStackView.axis = .vertical
        self.stepsStackView.alignment = .center
        self.horizontalStackView.addArrangedSubview(distanceStackView)
        self.horizontalStackView.addArrangedSubview(timeStackView)
        self.horizontalStackView.addArrangedSubview(altitudeStackView)
        self.horizontalStackView.addArrangedSubview(stepsStackView)
        self.distanceStackView.spacing = 5
        self.distanceStackView.addArrangedSubview(distance)
        self.distanceStackView.addArrangedSubview(distanceLabel)
        self.timeStackView.spacing = 5
        self.timeStackView.addArrangedSubview(time)
        self.timeStackView.addArrangedSubview(timeLabel)
        self.altitudeStackView.spacing = 5
        self.altitudeStackView.addArrangedSubview(altitude)
        self.altitudeStackView.addArrangedSubview(altitudeLabel)
        self.stepsStackView.spacing = 5
        self.stepsStackView.addArrangedSubview(steps)
        self.stepsStackView.addArrangedSubview(stepsLabel)
    }
    
    private func configureLayout() {
        self.date.translatesAutoresizingMaskIntoConstraints = false
        self.horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.date.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            self.date.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            self.horizontalStackView.topAnchor.constraint(greaterThanOrEqualTo: self.date.bottomAnchor, constant: 10),
            self.horizontalStackView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -15),
            self.horizontalStackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.horizontalStackView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
}

class ResultViewController: UIViewController {
    weak var coordinator: ResultViewCoordinator?
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: ResultViewController.createCompositionalLayout())
    private let topMain = TopMain()
    private let headerInfo = HeaderInfo()
    private let cellInfo = CellInfo()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.topItem?.title = topMain.distance + "km"
        collectionView.register(TopMainCell.self, forCellWithReuseIdentifier: TopMainCell.identifier)
        collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: MyCollectionViewCell.identifier)
        collectionView.register(Header.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Header.identifier)
        collectionView.frame = view.bounds
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private static func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            switch sectionNumber {
            case 0: return ResultViewController.firstLayoutSection()
            default: return ResultViewController.secondLayoutSection()
            }
        }
    }

    private static func firstLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(300))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private static func secondLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(130))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 3, leading: 10, bottom: 13, trailing: 10)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(130))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
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
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 6
        case 2: return 6
        default : return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TopMainCell.identifier,
                for: indexPath
            ) as? TopMainCell else {
                return UICollectionViewCell()
            }
            cell.configure(distance: topMain.distance, count: topMain.count, time: topMain.time, steps: topMain.steps)
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MyCollectionViewCell.identifier,
                for: indexPath
            ) as? MyCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.layer.cornerRadius = 10
            cell.backgroundColor = .white
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowRadius = 2
            cell.layer.shadowOpacity = 0.8
            cell.layer.shadowOffset = CGSize(width: 0, height: 0.5)
            cell.configure(date: cellInfo.date, distance: cellInfo.distance, time: cellInfo.time, altitude: cellInfo.altitude, steps: cellInfo.steps)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Header.identifier, for: indexPath) as? Header else {
            return UICollectionReusableView()
        }
        header.configure(month: headerInfo.month, count: headerInfo.count, distance: headerInfo.distance, time: headerInfo.time)
        return header
    }
}

extension ResultViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        let navigationBarChangePointY = 100.0
        if scrollView.contentOffset.y > navigationBarChangePointY {
            navigationBar.isHidden = false
            navigationBar.layer.opacity = Float(0.05 * (scrollView.contentOffset.y - navigationBarChangePointY))
        } else {
            navigationBar.isHidden = true
        }
    }
}
