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
        
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary
        
        let saveStatus = SecItemAdd(query, nil)
        
        if saveStatus != errSecSuccess {
            print("Error: \(saveStatus)")
        }
        
        if saveStatus == errSecDuplicateItem {
            update(data, account: key)
        }
    }
    
    static func update(_ data: Data, account: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account
        ] as CFDictionary
            
        let updatedData = [kSecValueData: data] as CFDictionary
        SecItemUpdate(query, updatedData)
    }
    
    static func getStringFromKeychain(forKey key: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        
        if status == errSecSuccess, let data = result as? Data {
            if let string = String(data: data, encoding: .utf8) {
                return string
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
