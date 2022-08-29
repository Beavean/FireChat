//
//  LoginViewModel.swift
//  FireChat
//
//  Created by Beavean on 29.08.2022.
//

import Foundation

protocol AuthenticationProtocol {
    var email: String? { get }
    var password: String? { get }
    var formIsValid: Bool { get }
}

struct LoginViewModel: AuthenticationProtocol {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
}
