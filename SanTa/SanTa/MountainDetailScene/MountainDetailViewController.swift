//
//  MountainDetailViewController.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/08.
//

import UIKit

class MountainDetailViewController: UIViewController {
    weak var mountainDetailViewCoordinator: MountainDetailViewCoordinator?
    private var mountainAnnotation: MountainAnnotation?
    
    convenience init(annotation: MountainAnnotation) {
        self.init()
        self.mountainAnnotation = annotation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
