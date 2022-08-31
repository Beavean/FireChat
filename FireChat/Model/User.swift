//
//  User.swift
//  FireChat
//
//  Created by Beavean on 31.08.2022.
//

import Foundation

struct User {
    let userId: String
    let profileImageUrl: String
    let username: String
    let fullName: String
    let email: String
    
    init(dictionary: [String: Any]) {
        self.userId = dictionary["uid"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.fullName = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
    }
}
