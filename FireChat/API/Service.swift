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
        K.collectionUsers.getDocuments { snapshot, error in
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
    
    static func fetchUser(withUserId userId: String, completion: @escaping(User) -> Void) {
        K.collectionUsers.document(userId).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    static func fetchConversations(completion: @escaping([Conversation]) -> Void) {
        var conversations = [Conversation]()
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let query = K.collectionMessages.document(userId).collection("recent-messages").order(by: "timestamp")
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                let dictionary = change.document.data()
                let message = Message(dictionary: dictionary)
                self.fetchUser(withUserId: message.toId) { user in
                    let conversation = Conversation(user: user, message: message)
                    conversations.append(conversation)
                    completion(conversations)
                }
            })
        }
    }
    
    static func uploadMessage(_ message: String, to user: User, completion:((Error?) -> Void)?) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let data = ["text": message, "fromId": currentUserId, "toId": user.userId, "timestamp": Timestamp(date: Date())] as [String : Any]
        K.collectionMessages.document(currentUserId).collection(user.userId).addDocument(data: data) { _ in
            K.collectionMessages.document(user.userId).collection(currentUserId).addDocument(data: data, completion: completion)
            K.collectionMessages.document(currentUserId).collection("recent-messages").document(user.userId).setData(data)
            K.collectionMessages.document(user.userId).collection("recent-messages").document(currentUserId).setData(data)
        }
    }
}
