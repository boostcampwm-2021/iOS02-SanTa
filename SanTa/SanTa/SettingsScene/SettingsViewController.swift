//
//  SettingsViewController.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import UIKit

class SettingsViewController: UIViewController {
    weak var coordinator: SettingsViewCoordinator?
    
    private var headerView: UIView = {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .white
        return headerView
    }()
    
    private var headerTitle: UILabel = {
        let headerTitle = UILabel()
        headerTitle.translatesAutoresizingMaskIntoConstraints = false
        headerTitle.text = "설정"
        headerTitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return headerTitle
    }()

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ToggleOptionCell.self, forCellReuseIdentifier: ToggleOptionCell.identifier)
        tableView.register(MapOptionCell.self, forCellReuseIdentifier: MapOptionCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.configureView()
    }

    private func configureTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = .systemGray5
    }
    
    private func configureView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.headerView)
        let headerViewConstrain = [
            self.headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.headerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.headerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 50.0),
        ]
        NSLayoutConstraint.activate(headerViewConstrain)
        
        self.headerView.addSubview(self.headerTitle)
        let headerTitleConstrain = [
            self.headerTitle.centerXAnchor.constraint(equalTo: self.headerView.centerXAnchor),
            self.headerTitle.centerYAnchor.constraint(equalTo: self.headerView.centerYAnchor),
        ]
        NSLayoutConstraint.activate(headerTitleConstrain)
        
        self.view.addSubview(self.tableView)
        let tableViewConstrain = [
            self.tableView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
        ]
        NSLayoutConstraint.activate(tableViewConstrain)
    }
    
    private func showMapActionSheet(cellTitle: String) {
        let alert = UIAlertController(title: "지도형식", message: nil, preferredStyle: .actionSheet)
        Map.allCases.forEach {
            alert.addAction(UIAlertAction(title: $0.description, style: .default, handler: { action in
                print(cellTitle, action.title!)
            }))
        }
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch settings[indexPath.section][indexPath.item] {
        case let option as ToggleOption:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: ToggleOptionCell.identifier,
                                                                for: indexPath) as? ToggleOptionCell
            else {
                return UITableViewCell()
            }
            cell.update(option: option)
            cell.delegate = self
            return cell
        case let option as MapOption:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: MapOptionCell.identifier,
                                                                for: indexPath) as? MapOptionCell
            else {
                return UITableViewCell()
            }
            cell.update(option: option)
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MapOptionCell else { return }
        guard let title = cell.title.text else { return }
        self.showMapActionSheet(cellTitle: title)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SettingsViewController: ToggleOptionCellDelegate {
    func toggleOptionCellSwitchChanged(_ cell: ToggleOptionCell, title: String, switchOn: Bool) {
        print(title, switchOn)
    }
}

//MARK: - dummy data

enum Map: String, CustomStringConvertible, CaseIterable {
    case infomation = "정보지도"
    case normal = "일반지도"
    case satellite = "위성지도"
    
    var description: String {
        return self.rawValue
    }
}

protocol Option {
    var text: String { get }
}

struct ToggleOption: Option {
    let text: String
    let toggle: Bool
}

struct MapOption: Option {
    let text: String
    let map: Map
}

let photoSettings1 = ToggleOption(text: "사진 기록하기", toggle: true)
let photoSettings2 = ToggleOption(text: "지도에 사진표시", toggle: true)

let autoSettins1 = ToggleOption(text: "자동 일시정지/재시작", toggle: false)
let autoSettins2 = ToggleOption(text: "자동 일시정지/재시작 음성 안내", toggle: false)

let voiceSettings1 = ToggleOption(text: "1킬로미터 마다 음성 안내", toggle: true)

let mapSetting1 = MapOption(text: "지도 형식", map: .infomation)
let mapSetting2 = ToggleOption(text: "지도에 등산로 표시", toggle: true)

let settings: [[Option]] = [[photoSettings1, photoSettings2],
                            [autoSettins1, autoSettins2],
                            [voiceSettings1],
                            [mapSetting1, mapSetting2]]
