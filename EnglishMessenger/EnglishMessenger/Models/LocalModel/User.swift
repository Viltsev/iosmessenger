//
//  User.swift
//  EnglishMessenger
//
//  Created by Данила on 17.02.2024.
//

import Foundation

struct User: Identifiable {
    var id = UUID()
    var username: String
    var email: String
    var phone: String
    var dateOfBirth: String
    var languageLevel: String
}
