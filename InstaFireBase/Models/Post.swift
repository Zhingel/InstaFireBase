//
//  Post.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 28.10.2021.
//

import Foundation

struct Post  {
    let imageURL: String
    
    init(dictionary: [String : Any]) {
        self.imageURL = dictionary["imageURL"] as? String ?? ""
    }
}
