//
//  User.swift
//  BookBridge
//
//  Created by Beste Kocaoglu on 15.11.2023.
//

import Foundation
import Firebase
import FirebaseAuth

struct User {
    let id: String
    let email: String
    

    init(id: String, email: String) {
        self.id = id
        self.email = email
    }

    init?(user: Firebase.User?) {
        guard let user = user else { return nil }
        self.init(id: user.uid, email: user.email ?? "")
    }
}
