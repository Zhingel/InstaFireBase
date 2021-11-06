//
//  CommentCell.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 06.11.2021.
//

import Foundation
import UIKit

class CommentCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
