//
//  TabBarController.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 23.10.2021.
//

import UIKit
import FirebaseAuth
class MainTabBarController : UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true)
            }
            return
        }
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
