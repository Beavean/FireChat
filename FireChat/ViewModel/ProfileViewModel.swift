//
//  ProfileViewModel.swift
//  FireChat
//
//  Created by Beavean on 02.09.2022.
//

import Foundation

enum ProfileViewModel: Int, CaseIterable {
    case accountInfo
    case accountSettings
    case savedMessages
    
    var description: String {
        switch self {
        case .accountInfo: return "Account Info"
        case .accountSettings: return "Settings"
        case .savedMessages: return "Saved Messages"
        }
    }
    
    var iconImageName: String {
        switch self {
        case .accountInfo: return "person.circle"
        case .accountSettings: return "gear"
        case .savedMessages: return "envelope"
        }
    }
}
