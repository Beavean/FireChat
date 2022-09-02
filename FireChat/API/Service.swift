//
//  Service.swift
//  FireChat
//
//  Created by Beavean on 31.08.2022.
//

import Firebase

struct Service {
    static func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in
                let dictionary = document.data()
                let user = User(dictionary: dictionary)
                users.append(user)
                completion(users)
            })
        }
    }
    
    static func fetchMessages(forUser user: User, completion: @escaping([Message]) -> Void) {
        var messages = [Message]()
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let query = K.collectionMessages.document(currentUserId).collection(user.userId).order(by: "timestamp")
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictionary = change.document.data()
                    messages.append(Message(dictionary: dictionary))
                    completion(messages)
                }
            })
        }
    }
    
    static func uploadMessage(_ message: String, to user: User, completion:((Error?) -> Void)?) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let data = ["text": message, "fromId": currentUserId, "toId": user.userId, "timestamp": Timestamp(date: Date())] as [String : Any]
        K.collectionMessages.document(currentUserId).collection(user.userId).addDocument(data: data) { _ in
            K.collectionMessages.document(user.userId).collection(currentUserId).addDocument(data: data, completion: completion)
        }
    }
}
