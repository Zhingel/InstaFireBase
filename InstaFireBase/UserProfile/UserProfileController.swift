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
    var userId: String?
    var isGridView = true
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(HomeControllerCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: "headerID")
        collectionView.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(logOutMethod))
        fetchUsers()
        
    }
    var isFinishedPaging = false
    fileprivate func paginatePosts() {
        guard let uid = self.user?.uid else {return}
        let ref = Database.database().reference().child("posts").child(uid)
        var query = ref.queryOrdered(byChild: "creationDate")
        if posts.count > 0 {
            let value = posts.last?.creationDate.timeIntervalSince1970
            print("gdfdfgdf",value)
            query = query.queryEnding(atValue: value)
        }
        query.queryLimited(toLast: 4).observeSingleEvent(of: .value) { snapshot in
            guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else {return}
            print("adsvdvd",allObjects.count)
            allObjects.reverse()
            if allObjects.count < 4 {
                self.isFinishedPaging = true
            }
            if self.posts.count > 0 && allObjects.count > 0 {
                allObjects.removeFirst()
                print("adsvdvcxxcxxcd",allObjects.count)
            }
            guard let user = self.user else {return}
            allObjects.forEach({ snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else {return}
                var post = Post(user: user, dictionary: dictionary)
                post.id = snapshot.key
                self.posts.append(post)
            })
            self.posts.forEach { post in
                print(post.id ?? "")
            }
            
            self.collectionView.reloadData()

        }

    }
    fileprivate func fetchPosts() {
        guard let uid = self.user?.uid else {return}
        let ref = Database.database().reference().child("posts").child(uid)
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            guard let user = self.user else {return}
            let post = Post(user: user, dictionary: dictionary)
            self.posts.insert(post, at: 0)
            self.collectionView.reloadData()
        }) { error in
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
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
//        guard let uid = Auth.auth().currentUser?.uid else {return}
        FirebaseApp.fetchUserWithUID(uid: uid) { user in
            self.user = user
            self.navigationItem.title = self.user?.username
            self.collectionView.reloadData()
//            self.fetchPosts()
            self.paginatePosts()
        }
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as! UserProfileHeader
        header.user = self.user
        header.didChangedToListView = {
            self.isGridView = false
            self.collectionView.reloadData()
        }
        header.didChangedToGridView = {
            self.isGridView = true
            self.collectionView.reloadData()
        }
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return isGridView ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return isGridView ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = isGridView ? (view.frame.width - 2) / 3 : view.frame.width
        let height = isGridView ? width : (40 + 8 + 8 + width + 100)
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: view.bounds.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.item == self.posts.count - 1 {
//            paginatePosts()
//        }
        if indexPath.item == self.posts.count - 1 && !isFinishedPaging {
            print("Paginating for posts", isFinishedPaging)
            paginatePosts()
        }
        if isGridView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! UserProfilePhotoCell
            cell.post = posts[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeControllerCell
            cell.post = posts[indexPath.item]
            return cell
        }
    }
}


