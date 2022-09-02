//
//  Constants.swift
//  FireChat
//
//  Created by Beavean on 02.09.2022.
//

import Firebase

struct K {
    
    static let collectionMessages = Firestore.firestore().collection("messages")
    static let collectionUsers = Firestore.firestore().collection("users")
}

