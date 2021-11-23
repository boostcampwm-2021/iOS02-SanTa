//
//  ResultDetailImagesViewController.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/23.
//

import UIKit

class ResultDetailImagesViewController: UIViewController {
    weak var coordinator: ResultDetailImagesViewCoordinator?
    
    var uiImages = [String: UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func configureViews() {
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.tintColor = .label
    }
}

extension ResultDetailImagesViewController {
    @objc func dismissViewController() {
        coordinator?.dismiss()
    }
}
