//
//  Post.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 28.10.2021.
//

import Foundation

struct Post  {
    let user: User
    let imageURL: String
    let caption: String
    
    init(user: User, dictionary: [String : Any]) {
        self.user = user
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.caption = dictionary["text"] as? String ?? ""
    }
}
