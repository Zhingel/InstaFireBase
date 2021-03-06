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

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostCellDelegate {
    func didLike(for cell: HomeControllerCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        var post = self.posts[indexPath.item]
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let postId = post.id else {return}
        let values = [uid: post.hasLiked == true ? 0 : 1]
        Database.database().reference().child("likes").child(postId).updateChildValues(values)
        post.hasLiked.toggle()
        self.posts[indexPath.item] = post
        self.collectionView.reloadItems(at: [indexPath])
        
    }
    
    func didTapComment(post: Post) {
        let vc = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.post = post
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    var posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = NSNotification.Name(rawValue: "UpdateFeed")
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: name, object: nil)
        collectionView.register(HomeControllerCell.self, forCellWithReuseIdentifier: "cell")
        setupNavigationBar()
        fetchData()
        fetchFollowingUserUIDs()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
   
    @objc fileprivate func handleUpdateFeed() {
        handleRefresh()
    }
    @objc fileprivate func handleRefresh() {
        posts.removeAll()
        fetchData()
        fetchFollowingUserUIDs()
    }
    fileprivate func fetchFollowingUserUIDs() {
        guard let userProfileUID = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("following").child(userProfileUID)
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let dictionaries = snapshot.value as? [String: Any] else {return}
            dictionaries.forEach { (key,value) in
                FirebaseApp.fetchUserWithUID(uid: key) { user in
                    self.fetchPostWithUser(user: user)
                }
            }
        } withCancel: { error in
            print(error)
        }

    }
    fileprivate func fetchData() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        FirebaseApp.fetchUserWithUID(uid: uid) { user in
            self.fetchPostWithUser(user: user) 
        }
    }
    fileprivate func fetchPostWithUser(user: User) {
        let uid = user.uid
        let ref = Database.database().reference().child("posts").child(uid)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            self.collectionView.refreshControl?.endRefreshing()
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                var post = Post(user: user, dictionary: dictionary)
                 post.id = key
                guard let userUid = Auth.auth().currentUser?.uid else {return}
                Database.database().reference().child("likes").child(key).child(userUid).observeSingleEvent(of: .value) { snapshot in
                    print(snapshot.value)
                    if let value = snapshot.value as? Int, value == 1 {
                        post.hasLiked = true
                    } else {
                        post.hasLiked = false
                    }
                    self.posts.append(post)
                    self.posts.sort {(p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate)  == .orderedDescending
                    }
                    self.collectionView?.reloadData() 
                }
            })
        }) { error in
            print("Failed to download", error)
        }
    }
    fileprivate func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera3"), style: .plain, target: self, action: #selector(handleCamera))
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo2"))
    }
    @objc fileprivate func handleCamera() {
        let cameraController = CameraController()
        let navController = UINavigationController(rootViewController: cameraController)
        navController.modalPresentationStyle = .custom
        present(navController, animated: true)
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
        cell.delegate = self
        return cell
    }
    
}
