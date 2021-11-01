//
//  SearchViewController.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 01.11.2021.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

class SearchViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    var users = [User]()
    var filteredUsers = [User]()
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Enter username"
        searchBar.delegate = self
        return searchBar
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(SearchViewControllerCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        setupNavigationBar()
        fetchUsers()
    }
    override func viewWillAppear(_ animated: Bool) {
        searchBar.isHidden = false
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = filteredUsers[indexPath.item]
        print(user.username)
        searchBar.resignFirstResponder()
        searchBar.isHidden = true
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.userId = user.uid
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            self.filteredUsers = self.users.filter { user -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            }
        }
        self.collectionView.reloadData()
    }
    fileprivate func fetchUsers() {
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let dictionaries = snapshot.value as? [String: Any] else {return}
            dictionaries.forEach { (key, value) in
                if key == Auth.auth().currentUser?.uid {
                    print("you founded")
                    return
                }
                guard let dictionary = value as? [String: Any] else {return}
                let user = User(uid: key, dictionary: dictionary)
                self.users.append(user)
            }
            self.users.sort {(u1, u2) -> Bool in
                return u1.username.compare(u2.username)  == .orderedAscending
            }
            self.filteredUsers = self.users
            self.collectionView.reloadData()
            
        } withCancel: { err in
            print(err)
        }

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchViewControllerCell
        cell.user = filteredUsers[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.bounds.width, height: 66)
    }
    
    fileprivate func setupNavigationBar() {
        guard let bar = navigationController?.navigationBar else {return}
        bar.addSubview(searchBar)
        searchBar.constraints(top: bar.topAnchor, bottom: bar.bottomAnchor, left: bar.leftAnchor, right: bar.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 8, width: 0, height: 0)
    }
}
