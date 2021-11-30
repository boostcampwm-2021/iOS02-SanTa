//
//  SettingsViewController.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import UIKit
import Combine

class SettingsViewController: UIViewController {
    weak var coordinator: SettingsViewCoordinator?

    private var headerView: UIView = {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .systemBackground
        return headerView
    }()

    private var headerTitle: UILabel = {
        let headerTitle = UILabel()
        headerTitle.translatesAutoresizingMaskIntoConstraints = false
        headerTitle.text = "설정"
        headerTitle.accessibilityTraits = .header
        headerTitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return headerTitle
    }()

    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ToggleOptionCell.self, forCellReuseIdentifier: ToggleOptionCell.identifier)
        tableView.register(MapOptionCell.self, forCellReuseIdentifier: MapOptionCell.identifier)
        tableView.backgroundColor = .systemGray5
        return tableView
    }()

    private var viewModel: SettingsViewModel?
    private var subscriptions = Set<AnyCancellable>()

    convenience init(viewModel: SettingsViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.configureView()
        self.bind()
        self.viewModel?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel?.viewWillAppear()
    }

    private func configureTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    private func configureView() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.tableView)
        self.headerView.addSubview(self.headerTitle)

        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.headerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.headerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 50.0)
        ])

        NSLayoutConstraint.activate([
            self.headerTitle.centerXAnchor.constraint(equalTo: self.headerView.centerXAnchor),
            self.headerTitle.centerYAnchor.constraint(equalTo: self.headerView.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }

    private func bind() {
        self.viewModel?.$settings.sink { [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &self.subscriptions)
        self.viewModel?.isPhotoRecordAvailable.sink { [weak self] bool in
            self?.configurePhotoPermission(bool)
        }.store(in: &self.subscriptions)
    }

    private func configurePhotoPermission(_ bool: Bool) {
        if !bool {
            let alert = UIAlertController(title: "사진 권한 활성화", message: "측정하는 동안 사진을 기록할 수 있도록 위치정보를 활성화해주세요", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "확인", style: .default) { _ in
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(url)
            }
            alert.addAction(confirm)
            self.present(alert, animated: true) {
                guard let photoSwitchCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ToggleOptionCell
                else { return }
                photoSwitchCell.changeSwitch()
            }
        }
    }

    private func showMapActionSheet(cellTitle: String) {
        let alert = UIAlertController(title: Settings.mapFormat.title, message: nil, preferredStyle: .actionSheet)
        Map.allCases.forEach {
            alert.addAction(UIAlertAction(title: $0.name, style: .default, handler: { action in
                guard let title = action.title else { return }
                guard let key = Settings(rawValue: cellTitle) else { return }
                self.viewModel?.change(value: title, key: key)
            }))
        }
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let itemCount = self.viewModel?.settingsCount else { return 0 }
        return itemCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.viewModel?.settings[indexPath.section] {
        case let option as ToggleOption:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: ToggleOptionCell.identifier,
                                                                for: indexPath) as? ToggleOptionCell
            else {
                return UITableViewCell()
            }
            cell.update(option: option)
            cell.delegate = self
            cell.configureAccessibility()
            return cell
        case let option as MapOption:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: MapOptionCell.identifier,
                                                                for: indexPath) as? MapOptionCell
            else {
                return UITableViewCell()
            }
            cell.update(option: option)
            cell.configureAccessibility()
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UIAccessibility.isVoiceOverRunning {
            guard let cell = tableView.cellForRow(at: indexPath) as? ToggleOptionCell else { return }
            cell.changeSwitch()
        }

        guard let cell = tableView.cellForRow(at: indexPath) as? MapOptionCell else { return }
        guard let title = cell.title.text else { return }
        self.showMapActionSheet(cellTitle: title)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension SettingsViewController: ToggleOptionCellDelegate {
    func toggleOptionCellSwitchChanged(_ cell: ToggleOptionCell, title: String, switchOn: Bool) {
        guard let key = Settings(rawValue: title) else { return }
        self.viewModel?.change(value: switchOn, key: key)
    }
}
