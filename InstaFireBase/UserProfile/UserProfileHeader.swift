//
//  UserProfileHeader.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 24.10.2021.
//

import UIKit

class UserProfileHeader: UICollectionViewCell {
    var user: User? {
        didSet {
            fetchImageProfile()
            usernameLabel.text = user?.username
        }
    }
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .red
        image.layer.cornerRadius = 90/2
        image.clipsToBounds = true
        return image
    }()
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "grid"), for: .normal)
        return button
    }()
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(named: "list"), for: .normal)
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
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3 
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
     
    func fetchImageProfile() {
        guard let profileImageURL = user?.profileImageURL else {return}
        guard let url = URL(string: profileImageURL) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch profile Image:", error)
                return
            }
            guard let data = data else {return}
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.profileImage.image = image
            }
        }.resume()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
