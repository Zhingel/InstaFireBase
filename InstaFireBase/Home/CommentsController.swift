//
//  CommentsController.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 04.11.2021.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase

class CommentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CustomTextViewDelegate {
    func addCommentFunc(for commentTextDelegate: String) {
        //guard let commentText = commentTextDelegate else {return}
        let postId = post?.id ?? ""
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let comment = ["text" : commentTextDelegate, "creationDate" : Date().timeIntervalSince1970, "uid": uid] as [String : Any]
        let ref = Database.database().reference().child("comments").child(postId).childByAutoId()
        ref.updateChildValues(comment)
        comments.removeAll()
        fetchComments()
        textFieldView.clearCommentTextField()
    }
    
    var comments = [Comment]()
    var post: Post?
    var user: User?
   
    let avatarImageView: CustomImageView = {
        let avatarImageView = CustomImageView()
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.clipsToBounds = true
        return avatarImageView
    }()
    lazy var containerView: UIView = {
        let containerView = UIView() 
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 80)
        let deviderView = UIView()
        deviderView.backgroundColor = .lightGray
        containerView.addSubview(avatarImageView)
        avatarImageView.constraints(top: containerView.topAnchor, bottom: containerView.bottomAnchor, left: containerView.leftAnchor, right: nil, paddingTop: 10, paddingBottom: -20, paddingLeft: 20, paddingRight: 0, width: 50, height: 50)
        containerView.addSubview(textFieldView)
        textFieldView.constraints(top: containerView.topAnchor, bottom: containerView.bottomAnchor, left: avatarImageView.rightAnchor, right: containerView.rightAnchor, paddingTop: 15, paddingBottom: -25, paddingLeft: 10, paddingRight: 10, width: 0, height: 0)
        containerView.addSubview(deviderView)
        deviderView.constraints(top: containerView.topAnchor, bottom: nil, left: containerView.leftAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 12, paddingRight: 12, width: 0, height: 0.5)
        return containerView
    }()
    lazy var textFieldView: CustomTextView = {
        let textFieldView = CustomTextView()
        textFieldView.delegate = self
        return textFieldView
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        fetchComments()
        collectionView.showsVerticalScrollIndicator = false
//        ////////////
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: "Cell")
        navigationItem.title = "Comments"
    }
  
//    @objc func addComment() {
//        guard let commentText = commentTextField.text else {return}
//        if !commentText.isEmpty {
//            let postId = post?.id ?? ""
//            guard let uid = Auth.auth().currentUser?.uid else {return}
//            let comment = ["text" : commentTextField.text ?? "", "creationDate" : Date().timeIntervalSince1970, "uid": uid] as [String : Any]
//            let ref = Database.database().reference().child("comments").child(postId).childByAutoId()
//            ref.updateChildValues(comment)
//            comments.removeAll()
//            fetchComments()
//        }
//    }
    
    fileprivate func fetchData() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        FirebaseApp.fetchUserWithUID(uid: uid) { user in
            self.user = user
            DispatchQueue.main.async {
                self.avatarImageView.loadImage(urlString: self.user?.profileImageURL ?? "")
            }
        }
    }
    fileprivate func fetchComments() {
        let postId = post?.id ?? ""
        let ref = Database.database().reference().child("comments").child(postId)
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let dictionaries = snapshot.value as? [String: Any] else {return}
            dictionaries.forEach { key, value in
                guard let dictionary = value as? [String: Any] else {return}
                let comment = Comment(commentId: key, dictionary: dictionary)
                self.comments.append(comment)
            }
            self.comments.sort {(p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate)  == .orderedDescending
            }
            self.collectionView.reloadData()
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 60)
        let cellSize = CommentCell(frame: frame)
        cellSize.comment = comments[indexPath.item]
        cellSize.layoutIfNeeded()
        cellSize.autoresizesSubviews = true
        let targeSize = CGSize(width: view.bounds.width, height: 1000)
        let autoSized = cellSize.systemLayoutSizeFitting(targeSize)
        let height = max(60, autoSized.height)
        return CGSize(width: view.bounds.width, height: 60)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: view.bounds.width, height: 70)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! HeaderCell
        header.post = self.post
        return header
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        comments.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CommentCell
        cell.comment = comments[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 45, right: 0)
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    override var inputAccessoryView: UIView? {
        get {
          return containerView
        }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
