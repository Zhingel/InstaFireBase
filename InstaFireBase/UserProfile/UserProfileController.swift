//
//  UserProfileController.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 23.10.2021.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class UserProfileController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var posts = [Post]()
    var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: "headerID")
        collectionView.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(logOutMethod))
        fetchUsers()
        fetchPosts()
    }
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("posts").child(uid)
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let dictionaries = snapshot.value as? [String : Any] else {return}
            dictionaries.forEach { (key, value) in
//                print("Key: \(key), Value: \(value)")
                guard let dictionary = value as? [String : Any] else {return}
                let post = Post(dictionary: dictionary)
                self.posts.append(post)
                
                
            }
            self.collectionView.reloadData()
        } withCancel: { error in
            print("Failed to download", error)
        }

        
    }
    
    @objc func logOutMethod() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: {_ in
            do {
                try Auth.auth().signOut()
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true)
            } catch {
                print("Some problem with LogOut")
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    fileprivate func fetchUsers() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            self.user = User(dictionary: dictionary)
            self.navigationItem.title = self.user?.username
            self.collectionView.reloadData()
        }) {err in
            print("fail fetch user", err)
        }
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as! UserProfileHeader
        header.user = self.user
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: view.bounds.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! UserProfilePhotoCell
        cell.post = posts[indexPath.item]
        return cell
    }
}


struct User {
    let username: String
    let profileImageURL: String
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageUrl"] as? String ?? ""
    }
}
