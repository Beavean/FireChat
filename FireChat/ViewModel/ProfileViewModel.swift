//
//  ProfileViewModel.swift
//  FireChat
//
//  Created by Beavean on 02.09.2022.
//

import Foundation

enum ProfileViewModel: Int, CaseIterable {
    case accountInfo = 0
    case accountSettings = 1
    
    var description: String {
        switch self {
        case .accountInfo: return "Account Info"
        case .accountSettings: return "Settings"
        }
    }
    
    var iconImageName: String {
        switch self {
        case .accountInfo: return "person.circle"
        case .accountSettings: return "gear"
        }
    }
}
