//
//  UserProfilePhotoCell.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 28.10.2021.
//

import Foundation
import UIKit

class UserProfilePhotoCell : UICollectionViewCell {
    var post: Post? {
        didSet {
            guard let urlImage = post?.imageURL else {return}
          //  if url.absoluteString != self.post?.imageURL {return}
            imageView.loadImage(urlString: urlImage)
            
           

        }
    }
    let imageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.constraints(top: self.topAnchor, bottom: self.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
