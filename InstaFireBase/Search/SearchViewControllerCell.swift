//
//  SearchViewControllerCell.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 01.11.2021.
//

import Foundation
import UIKit
class SearchViewControllerCell: UICollectionViewCell {
    var user: User? {
        didSet {
            textLabel.text = user?.username
            guard let url = user?.profileImageURL else {return}
            userProfileImage.loadImage(urlString: url)
        }
    }
    let userProfileImage: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .green
        return iv
    }()
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(userProfileImage)
        userProfileImage.constraints(top: nil, bottom: nil, left: leftAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 50, height: 50)
        userProfileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        userProfileImage.layer.cornerRadius = 50/2
        userProfileImage.clipsToBounds = true
        addSubview(textLabel)
        textLabel.constraints(top: nil, bottom: nil, left: userProfileImage.rightAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 8, width: 0, height: 0)
        textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        let divider = UIView()
        divider.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(divider)
        divider.constraints(top: nil, bottom: bottomAnchor, left: userProfileImage.rightAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0.5)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
