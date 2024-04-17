//
//  ChatsStorage.swift
//  EnglishMessenger
//
//  Created by Данила on 17.04.2024.
//

import Foundation

actor ChatsStorage {
    private var cache = NSCache<NSString, NSArray>()
    
    init(cacheCountLimit: Int) {
        cache.countLimit = cacheCountLimit
    }
    
    func getAllCachedChats(forKey key: String) async throws -> [User]? {
        let nsKey = key as NSString
        return cache.object(forKey: nsKey) as? [User]
    }
    
    func cacheNewChats(_ newChats: [User], forKey key: String) async throws -> [User] {
        let nsKey = key as NSString
        if var cachedChats = cache.object(forKey: nsKey) as? [User] {
            let newCachedChats = newChats.filter { newChat in
                !cachedChats.contains { $0.id == newChat.id }
            }
            cachedChats.append(contentsOf: newCachedChats)
            cache.setObject(cachedChats as NSArray, forKey: nsKey)
            return newCachedChats
        } else {
            let nsNewChats = newChats as NSArray
            cache.setObject(nsNewChats, forKey: nsKey)
            return newChats
        }
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}
