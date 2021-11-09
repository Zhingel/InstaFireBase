//
//  UserProfileHeader.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 24.10.2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase

class UserProfileHeader: UICollectionViewCell {
    var didChangedToListView: (() -> Void)?
    var didChangedToGridView: (() -> Void)?
    var user: User? {
        didSet {
            guard let profileImageURL = user?.profileImageURL else {return}
            profileImage.loadImage(urlString: profileImageURL)
            usernameLabel.text = user?.username
            setupFollowButton()
        }
    }
    let profileImage: CustomImageView = {
        let image = CustomImageView()
        image.backgroundColor = .white
        image.layer.cornerRadius = 90/2
        image.clipsToBounds = true
        return image
    }()
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "grid"), for: .normal)
        button.addTarget(self, action: #selector(handleToGridItem), for: .touchUpInside)
        return button
    }()
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(named: "list"), for: .normal)
        button.addTarget(self, action: #selector(handleToListView), for: .touchUpInside)
        return button
    }()
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(named: "ribbon"), for: .normal)
        return button
    }()
    let usernameLabel: UILabel = {
        let name = UILabel()
        name.text = "username"
        name.font = UIFont.boldSystemFont(ofSize: 14)
        return name
    }()
    let postsLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    let followersLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    let followingLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
       // button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(handleFollowButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addSubview(profileImage)
        addSubview(usernameLabel)
        profileImage.constraints(top: self.topAnchor, bottom: nil, left: self.leftAnchor, right: nil, paddingTop: 20, paddingBottom: 0, paddingLeft: 12, paddingRight: 0, width: 90, height: 90)
        usernameLabel.constraints(top: profileImage.bottomAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingBottom: 0, paddingLeft: 12, paddingRight: 12, width: 0, height: 0)
        
        tabbarView()
        followersBarView()
    }
    @objc fileprivate func handleToGridItem() {
        gridButton.tintColor = UIColor.rgb(red: 17, green: 154, blue: 257)
        listButton.tintColor = UIColor(white: 0, alpha: 0.2)
        didChangedToGridView?()
    }
    @objc fileprivate func handleToListView() {
        listButton.tintColor = UIColor.rgb(red: 17, green: 154, blue: 257)
        gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
        didChangedToListView?()
    }
    @objc fileprivate func handleFollowButton() {
        guard let profileUID = Auth.auth().currentUser?.uid else {return}
        guard let userUID = user?.uid else {return}
        let ref = Database.database().reference().child("following").child(profileUID)
        if editProfileButton.titleLabel?.text == "Unfollow" {
            ref.child(userUID).removeValue { error, ref in
                if let error = error {
                    print(error)
                    return
                }
                self.editProfileButton.setTitle("Follow", for: .normal)
                self.editProfileButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 257)
                self.editProfileButton.setTitleColor(.white, for: .normal)
                self.editProfileButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
            }
        } else {
            let values = [userUID : 1]
            ref.updateChildValues(values) { error, ref in
                if let error = error {
                    print(error)
                    return
                }
                self.editProfileButton.setTitle("Unfollow", for: .normal)
                self.editProfileButton.backgroundColor = .white
                self.editProfileButton.setTitleColor(.black, for: .normal)
            }
        }
    }
    fileprivate func setupFollowButton() {
        guard let profileUID = Auth.auth().currentUser?.uid else {return}
        guard let userUID = user?.uid else {return}
        if profileUID == userUID {
            editProfileButton.setTitle("Edit profile", for: .normal)
        } else {
            let ref = Database.database().reference().child("following").child(profileUID).child(userUID)
            ref.observeSingleEvent(of: .value) { snapshot in
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    self.editProfileButton.setTitle("Unfollow", for: .normal)
                } else {
                    self.editProfileButton.setTitle("Follow", for: .normal)
                    self.editProfileButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 257)
                    self.editProfileButton.setTitleColor(.white, for: .normal)
                    self.editProfileButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
                }
                
            } withCancel: { error in
                print(error)
            }
        }
    }
    fileprivate func followersBarView() {
        let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        addSubview(editProfileButton)
        stackView.constraints(top: self.topAnchor, bottom: nil, left: profileImage.rightAnchor, right: self.rightAnchor, paddingTop: 20, paddingBottom: 0, paddingLeft: 25, paddingRight: 15, width: 0, height: 0)
        editProfileButton.constraints(top: stackView.bottomAnchor, bottom: nil, left: profileImage.rightAnchor, right: self.rightAnchor, paddingTop: 10, paddingBottom: 0, paddingLeft: 25, paddingRight: 15, width: 0, height: 34)
    }
    fileprivate func tabbarView() {
        let dividerUpper = UIView()
        dividerUpper.backgroundColor = .lightGray
        let dividerDown = UIView()
        dividerDown.backgroundColor = .lightGray
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        addSubview(dividerUpper)
        addSubview(dividerDown)
        stackView.constraints(top: nil, bottom: self.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 40)
        dividerUpper.constraints(top: nil, bottom: stackView.topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        dividerDown.constraints(top: stackView.bottomAnchor , bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
