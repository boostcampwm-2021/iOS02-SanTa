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
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.identifier)
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
        if section == 0 {
            return settings.photoSettings.count
        } else if section == 1 {
            return settings.autoSettins.count
        } else if section == 2 {
            return settings.voiceSettings.count
        } else {
            return settings.mapSettings.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier, for: indexPath)
                as? SettingsCell
        else {
            return UITableViewCell()
        }
        if indexPath.section == 0 {
            cell.update(option: settings.photoSettings[indexPath.row])
        } else if indexPath.section == 1 {
            cell.update(option: settings.autoSettins[indexPath.row])
        } else if indexPath.section == 2 {
            cell.update(option: settings.voiceSettings[indexPath.row])
        } else {
            cell.update(option: settings.mapSettings[indexPath.row])
        }
        return cell
    }
}

struct Option {
    let text: String
    let check: Bool
}

struct Settings {
    let photoSettings: [Option]
    let autoSettins: [Option]
    let voiceSettings: [Option]
    let mapSettings: [Option]
}

let photoSettings1 = Option(text: "사진 기록하기", check: true)
let photoSettings2 = Option(text: "지도에 사진표시", check: true)

let autoSettins1 = Option(text: "자동 일시정지/재시작", check: false)
let autoSettins2 = Option(text: "자동 일시정지/재시작 음성 안내", check: false)

let voiceSettings1 = Option(text: "1킬로미터 마다 음성 안내", check: true)

let mapSetting1 = Option(text: "지도 형식", check: true)
let mapSetting2 = Option(text: "지도에 등산로 표시", check: true)

let settings = Settings(photoSettings: [photoSettings1, photoSettings2],
                        autoSettins: [autoSettins1, autoSettins2],
                        voiceSettings: [voiceSettings1],
                        mapSettings: [mapSetting1, mapSetting2])

//protocol OptionKey {
//    var text: String { get }
//}
//
//struct ToggleOption: OptionKey {
//    let text: String
//    let check: Bool
//}

//struct ListOption: OptionKey {
//    let text: String
//    let list: [String]
//}
//
//struct Settings {
//    let photoSettings: [OptionKey]
//    let autoSettins: [OptionKey]
//    let voiceSettings: [OptionKey]
//    let mapSettings: [OptionKey]
//}
//
//let photoSettings1 = ToggleOption(text: "사진 기록하기", check: true)
//let photoSettings2 = ToggleOption(text: "지도에 사진표시", check: true)
//
//let autoSettins1 = ToggleOption(text: "자동 일시정지/재시작", check: false)
//let autoSettins2 = ToggleOption(text: "자동 일시정지/재시작 음성 안내", check: false)
//
//let voiceSettings1 = ToggleOption(text: "1킬로미터 마다 음성 안내", check: true)
//
//let mapSetting1 = ListOption(text: "지도 형식", list: ["정보지도, 일반지도, 위성지도"])
//let mapSetting2 = ToggleOption(text: "지도에 등산로 표시", check: true)
//
//let settings = Settings(photoSettings: [photoSettings1, photoSettings2],
//                        autoSettins: [autoSettins1, autoSettins2],
//                        voiceSettings: [voiceSettings1],
//                        mapSettings: [mapSetting1, mapSetting2])
