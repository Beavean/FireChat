//
//  AuthenticationService.swift
//  FireChat
//
//  Created by Beavean on 30.08.2022.
//

import FirebaseStorage
import Firebase
import UIKit

struct RegistrationCredentials {
    let email: String
    let password: String
    let fullName: String
    let username: String
    let profileImage: UIImage
}

struct AuthenticationService {
    
    static let shared = AuthenticationService()
    
    func logUserIn(withEmail email: String, password: String, completion: @escaping ((AuthDataResult?, Error?) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
        }
    
    func createUser(credentials: RegistrationCredentials, completion: ((Error?) -> Void)?) {
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let reference = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        reference.putData(imageData, metadata: nil) { meta, error in
            if let error = error {
                completion!(error)
                return
            }
            reference.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else { return }
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                    if let error = error {
                        completion!(error)
                        return
                    }
                    guard let userId = result?.user.uid else { return }
                    let  data = ["email": credentials.email,
                                 "fullname": credentials.fullName,
                                 "profileImageUrl": profileImageUrl,
                                 "uid": userId,
                                 "username": credentials.username] as [String: Any]
                    Firestore.firestore().collection("users").document(userId).setData(data, completion: completion)
                }
            }
        }
    }
}
