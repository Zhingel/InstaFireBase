//
//  TabBarController.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 23.10.2021.
//

import UIKit
class MainTabBarController : UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let navigationController = UINavigationController(rootViewController: userProfileController)
        navigationController.tabBarItem.image = UIImage(named: "profile_unselected")
        navigationController.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        tabBar.tintColor = .black
        navigationController.navigationBar.scrollEdgeAppearance = navigationController.navigationBar.standardAppearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        viewControllers = [navigationController, UIViewController()]
        
    }
}
