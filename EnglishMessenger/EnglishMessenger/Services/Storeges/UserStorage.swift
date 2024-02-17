//
//  UserStorage.swift
//  EnglishMessenger
//
//  Created by Данила on 17.02.2024.
//

import Foundation

enum UserStorageKey: String {
    case authStatus
}


struct UserStorage {
    
    private let userDefaults = UserDefaults.standard
    
    static var shared = UserStorage()
    
    private init() {}
    
    var authStatus: Bool {
        get {
            userDefaults.bool(forKey: UserStorageKey.authStatus.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: UserStorageKey.authStatus.rawValue)
        }
    }
}
