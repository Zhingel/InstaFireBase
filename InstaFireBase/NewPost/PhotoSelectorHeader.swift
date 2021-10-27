//
//  PhotoSelectorHeader.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 27.10.2021.
//

import Foundation
import UIKit

class PhotoSelectorHeader: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.constraints(top: self.topAnchor, bottom: self.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
