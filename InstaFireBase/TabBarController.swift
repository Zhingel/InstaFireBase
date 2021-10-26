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
        setupViewControllers()
    }
    func setupViewControllers() {
        let homeNavController = setupNavigationController(imageName: "home_unselected", selectedImageName: "home_selected")
        let searchNavController = setupNavigationController(imageName: "search_unselected", selectedImageName: "search_selected")
        let plusNavController = setupNavigationController(imageName: "plus_unselected", selectedImageName: "plus_selected")
        let likeNavController = setupNavigationController(imageName: "like_unselected", selectedImageName: "like_selected")
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let profileNavigationController = setupNavigationController(imageName: "profile_unselected", selectedImageName: "profile_selected", viewController: userProfileController)
        tabBar.tintColor = .black
        viewControllers = [homeNavController, searchNavController, plusNavController, likeNavController, profileNavigationController]
    }
    func setupNavigationController(imageName: String, selectedImageName: String, viewController: UIViewController = UIViewController()) -> UINavigationController {
       let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = UIImage(named: imageName)
        navController.tabBarItem.selectedImage = UIImage(named: selectedImageName)
        navController.navigationBar.scrollEdgeAppearance = navController.navigationBar.standardAppearance
        return navController
    }
}
