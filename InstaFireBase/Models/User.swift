//
//  User.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 29.10.2021.
//

import Foundation

struct User {
    let username: String
    let profileImageURL: String
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageUrl"] as? String ?? ""
    }
}
