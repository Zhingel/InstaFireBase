//
//  User.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 29.10.2021.
//

import Foundation

struct User {
    let uid: String
    let username: String
    let profileImageURL: String
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid 
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageUrl"] as? String ?? ""
    }
}
