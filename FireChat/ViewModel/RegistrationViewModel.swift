//
//  RegistrationViewModel.swift
//  FireChat
//
//  Created by Beavean on 29.08.2022.
//

import Foundation

struct RegistrationViewModel: AuthenticationProtocol {
    var email: String?
    var password: String?
    var fullName: String?
    var username: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
        && password?.isEmpty == false
        && fullName?.isEmpty == false
        && username?.isEmpty == false
    }
}
