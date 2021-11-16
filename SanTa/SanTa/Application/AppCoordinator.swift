//
//  AppCoordinator.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    
    func start ()
}

class AppCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    let window: UIWindow?

    private var firstViewController: UIViewController!
    private let coreDataStorage = CoreDataStorage()
    private let mountainExtractor = MountainExtractor()
    private let userDefaultsStorage = DefaultUserDefaultsStorage()

    init(_ window: UIWindow?) {
        self.window = window
        window?.makeKeyAndVisible()
    }

    func start() {
        self.userDefaultsStorage.makeFirstData()
        let tabBarController = self.setTabBarController()
        self.window?.rootViewController = tabBarController
    }

    func setTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.delegate = self
        tabBarController.tabBar.backgroundColor = UIColor.white

        let firstItem = UITabBarItem(title: "시작", image: nil, tag: 0)
        let secondItem = UITabBarItem(title: "기록", image: nil, tag: 1)
        let thirdItem = UITabBarItem(title: "목록", image: nil, tag: 2)
        let fourthItem = UITabBarItem(title: "설정", image: nil, tag: 3)
        
        let mapViewCoordinator = MapViewCoordinator(userDefaultsStorage: self.userDefaultsStorage,
                                                    mountainExtractor: self.mountainExtractor,
                                                    coreDataStorage: self.coreDataStorage)
        mapViewCoordinator.parentCoordinator = self
        childCoordinators.append(mapViewCoordinator)
        let mapViewController = mapViewCoordinator.startPush()
        mapViewController.tabBarItem = firstItem
        mapViewController.tabBarItem.image = .init(systemName: "play.fill")
        
        let resultViewCoordinator = ResultViewCoordinator(coreDataStorage: self.coreDataStorage)
        resultViewCoordinator.parentCoordinator = self
        childCoordinators.append(resultViewCoordinator)
        let resultViewController = resultViewCoordinator.startPush()
        resultViewController.tabBarItem = secondItem
        resultViewController.tabBarItem.image = .init(systemName: "list.dash")
        
        let mountainListViewCoordinator = MountainListViewCoordinator(userDefaultsStorage: self.userDefaultsStorage,
                                                                      mountainExtractor: self.mountainExtractor)
        mountainListViewCoordinator.parentCoordinator = self
        childCoordinators.append(mountainListViewCoordinator)
        let mountainListViewController = mountainListViewCoordinator.startPush()
        mountainListViewController.tabBarItem = thirdItem
        mountainListViewController.tabBarItem.image = .init(systemName: "text.below.photo")
        
        let settingsViewCoordinator = SettingsViewCoordinator(userDefaultsStorage: self.userDefaultsStorage)
        settingsViewCoordinator.parentCoordinator = self
        childCoordinators.append(settingsViewCoordinator)
        let settingsViewController = settingsViewCoordinator.startPush()
        settingsViewController.tabBarItem = fourthItem
        settingsViewController.tabBarItem.image = .init(systemName: "gearshape.fill")

        tabBarController.viewControllers = [mapViewController, resultViewController, mountainListViewController, settingsViewController]

        return tabBarController
    }
}

extension AppCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}
