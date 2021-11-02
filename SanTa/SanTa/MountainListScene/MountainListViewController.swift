//
//  MountainListViewController.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import UIKit

class MountainListViewController: UIViewController {
    
    weak var coordinator: MountainListViewCoordinator?
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MountainCell.self, forCellReuseIdentifier: MountainCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.configureView()
    }
    
    private func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func configureView() {
        self.view.addSubview(self.tableView)
        let tableViewConstrain = [
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
        ]
        NSLayoutConstraint.activate(tableViewConstrain)
    }
}

extension MountainListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: MountainCell.identifier, for: indexPath)
                as? MountainCell
        else {
            return UITableViewCell()
        }
        cell.update(mountain: dummy[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

struct Mountain {
    let name: String
    let height: String
    let location: String
}

let dummy = [Mountain(name: "백두산", height: "1000m", location: "북한"),
             Mountain(name: "한라산", height: "2000m", location: "제주도")]
