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

class CommentsController: UICollectionViewController {
    var comments = [Comment]()
    var post: Post?
    var user: User?
    let commentTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Enter Comment"
        return text
    }()
    let avatarImageView: CustomImageView = {
        let avatarImageView = CustomImageView()
        avatarImageView.layer.cornerRadius = 25
        return avatarImageView
    }()
    lazy var containerView: UIView = {
        let containerView = UIView()
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
    lazy var textFieldView: UIView = {
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sendButton.addTarget(self, action: #selector(addComment), for: .touchUpInside)
        let textFieldView = UIView()
        textFieldView.layer.borderWidth = 0.5
        textFieldView.layer.cornerRadius = 20
        textFieldView.layer.borderColor = UIColor.lightGray.cgColor
        textFieldView.addSubview(sendButton)
        sendButton.constraints(top: textFieldView.topAnchor, bottom: textFieldView.bottomAnchor, left: nil, right: textFieldView.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 10, width: 50, height: 0)
        textFieldView.addSubview(commentTextField)
        commentTextField.constraints(top: textFieldView.topAnchor, bottom: textFieldView.bottomAnchor, left: textFieldView.leftAnchor, right: sendButton.leftAnchor, paddingTop: 8, paddingBottom: -8, paddingLeft: 20, paddingRight: 8, width: 0, height: 0)
        return textFieldView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        fetchComments()
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: "Cell")
        navigationItem.title = "Comments"
        
    }
    @objc func addComment() {
        print("Inserting comment:", commentTextField.text ?? "")
        let postId = post?.id ?? ""
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let comment = ["text" : commentTextField.text ?? "", "creationDate" : Date().timeIntervalSince1970, "uid": uid] as [String : Any]
        let ref = Database.database().reference().child("comments").child(postId).childByAutoId()
        ref.updateChildValues(comment)
    }
    
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
            self.collectionView.reloadData()
        }
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        comments.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CommentCell
        return cell
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
