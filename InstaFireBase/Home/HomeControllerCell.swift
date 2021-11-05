//
//  HomeControllerCell.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 28.10.2021.
//

import Foundation
import UIKit

protocol HomePostCellDelegate {
    func didTapComment(post: Post)
}

class HomeControllerCell: UICollectionViewCell {
    var delegate: HomePostCellDelegate?
    var post: Post? {
        didSet {
            guard let imageURL = post?.imageURL else {return}
            imageView.loadImage(urlString: imageURL)
            usernameLabel.text = post?.user.username
            guard let profileImageURL = post?.user.profileImageURL else {return}
            userProfileImage.loadImage(urlString: profileImageURL)
            setupAttributedCaption()
        }
    }
    let imageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    let userProfileImage: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        iv.clipsToBounds = true
        return iv
    }()
    let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .black
        return button
    }()
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like_unselected"), for: .normal)
        button.tintColor = .black
        return button
    }()
    let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return button
    }()
    let messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "send2"), for: .normal)
        button.tintColor = .black
        return button
    }()
    let ribbonButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon"), for: .normal)
        button.tintColor = .black
        return button
    }()
    let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(userProfileImage)
        addSubview(optionsButton)
        addSubview(usernameLabel)
        addSubview(ribbonButton)
        addSubview(captionLabel)
        userProfileImage.constraints(top: topAnchor, bottom: nil, left: leftAnchor, right: nil, paddingTop: 8, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 40, height: 40)
        userProfileImage.layer.cornerRadius = 20
        imageView.constraints(top: userProfileImage.bottomAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        imageView.heightAnchor.constraint(equalToConstant: self.bounds.width).isActive = true
        optionsButton.constraints(top: topAnchor, bottom: nil, left: nil, right: rightAnchor, paddingTop: 16, paddingBottom: 0, paddingLeft: 0, paddingRight: 8, width: 0, height: 0)
        usernameLabel.constraints(top: topAnchor, bottom: nil, left: userProfileImage.rightAnchor, right: optionsButton.rightAnchor, paddingTop: 20, paddingBottom: 0, paddingLeft: 8, paddingRight: 8, width: 0, height: 0)
        ribbonButton.constraints(top: imageView.bottomAnchor, bottom: nil, left: nil, right: rightAnchor, paddingTop: 8, paddingBottom: 0, paddingLeft: 0, paddingRight: 10, width: 0, height: 0)
        setupStackView()
        captionLabel.constraints(top: ribbonButton.bottomAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingBottom: 8, paddingLeft: 8, paddingRight: 8, width: 0, height: 0)
    }
    @objc fileprivate func handleComment() {
        guard let post = self.post else {return}
        delegate?.didTapComment(post: post)
    }
    fileprivate func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, messageButton])
        addSubview(stackView)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 14
        stackView.constraints(top: imageView.bottomAnchor, bottom: nil, left: leftAnchor, right: nil, paddingTop: 8, paddingBottom: 0, paddingLeft: 10, paddingRight: 0, width: 0, height: 0)
    }
    fileprivate func setupAttributedCaption() {
        guard let post = self.post else {return}
        let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: " \(post.caption)",attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 4)]))
        let time = post.creationDate.timeAgoDisplay()
        attributedText.append(NSAttributedString(string: time, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.gray]))
        self.captionLabel.attributedText = attributedText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
