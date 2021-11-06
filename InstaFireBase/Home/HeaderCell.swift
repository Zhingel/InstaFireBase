//
//  HeaderCell.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 06.11.2021.
//

import Foundation
import UIKit

class HeaderCell: UICollectionViewCell {
    var post: Post? {
        didSet {
            guard let post = post else {return}
            commentImageView.loadImage(urlString: post.user.profileImageURL)
            let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)])
            attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]))
            attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 4)]))
            let time = post.creationDate.timeAgoDisplay()
            attributedText.append(NSAttributedString(string: time, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor : UIColor.gray]))
            self.userNameAndComment.attributedText = attributedText
        }
    }
    let commentImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        return iv
    }()
    let userNameAndComment: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(commentImageView)
        commentImageView.constraints(top: nil, bottom: nil, left: self.leftAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 12, paddingRight: 0, width: 40, height: 40)
        commentImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.addSubview(userNameAndComment)
        userNameAndComment.constraints(top: self.topAnchor, bottom: nil, left: commentImageView.rightAnchor, right: self.rightAnchor, paddingTop: 12, paddingBottom: 0, paddingLeft: 10, paddingRight: 20, width: 0, height: 0)
        let divider = UIView()
        divider.backgroundColor = .lightGray
        self.addSubview(divider)
        divider.constraints(top: nil, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
