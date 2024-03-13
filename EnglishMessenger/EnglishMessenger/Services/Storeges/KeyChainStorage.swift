//
//  KeyChainStorage.swift
//  EnglishMessenger
//
//  Created by Данила on 13.03.2024.
//

import Foundation
import Security

struct KeyChainStorage {    
    static func saveStringToKeychain(string: String, forKey key: String) {
        guard let data = string.data(using: .utf8) else { return }
        
        var query = [String: Any]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrAccount as String] = key
        query[kSecValueData as String] = data
        query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked
        
        SecItemDelete(query as CFDictionary)
    }
    
    static func getStringFromKeychain(forKey key: String) -> String? {
        var query = [String: Any]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrAccount as String] = key
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanFalse
        query[kSecReturnData as String] = kCFBooleanTrue
        
        var dataTypeRef: AnyObject?
    
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let retrievedData = dataTypeRef as? Data {
            if let retrievedString = String(data: retrievedData, encoding: .utf8) {
                return retrievedString
            }
        }
        
        return nil
    }
}
