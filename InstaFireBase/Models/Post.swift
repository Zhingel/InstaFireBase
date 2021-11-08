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
    let creationDate: Date
    var id: String?
    var hasLiked: Bool = false
    
    init(user: User, dictionary: [String : Any]) {
        self.user = user
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.caption = dictionary["text"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
