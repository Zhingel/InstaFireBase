//
//  HomeController.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 28.10.2021.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(HomeControllerCell.self, forCellWithReuseIdentifier: "cell")
        setupNavigationBar()
        fetchData()
    }
    fileprivate func fetchData() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let userDictionary = snapshot.value as? [String: Any] else {return}
            let user = User(dictionary: userDictionary)
            let ref = Database.database().reference().child("posts").child(uid)
            ref.observeSingleEvent(of: .value, with: { snapshot in
                guard let dictionaries = snapshot.value as? [String: Any] else { return }
                dictionaries.forEach({ (key, value) in
                    guard let dictionary = value as? [String: Any] else { return }
                    let post = Post(user: user, dictionary: dictionary)
                    self.posts.append(post)
                })
                self.collectionView?.reloadData()
            }) { error in
                print("Failed to download", error)
            }
        } withCancel: { err in
            print(err)
        }
    }

    fileprivate func setupNavigationBar() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo2"))
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        posts.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width
        let height = 40 + 8 + 8 + width + 100
        return CGSize(width: width, height: height)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeControllerCell
        cell.post = posts[indexPath.item]
        return cell
    }
}
