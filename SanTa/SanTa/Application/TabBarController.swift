//
//  TabBarController.swift
//  SanTa
//
//  Created by shin jae ung on 2021/10/28.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .blue
        tabBar.unselectedItemTintColor = .label
        tabBar.backgroundColor = .systemBackground
        setUpTabBar()
    }

    private func setUpTabBar() {
        let homeViewController = UINavigationController(rootViewController: MapViewController())
        homeViewController.tabBarItem.image = .init(systemName: "play.fill")
        homeViewController.title = "시작"
        
        let homeViewController2 = UINavigationController(rootViewController: MapViewController())
        homeViewController2.tabBarItem.image = .init(systemName: "play.fill")
        homeViewController2.title = "시작"
        
        viewControllers = [homeViewController, homeViewController2]
    }
    
}
