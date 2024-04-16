//
//  User.swift
//  EnglishMessenger
//
//  Created by Данила on 17.02.2024.
//

import Foundation

struct User: Identifiable, Hashable {
    var id = UUID()
    var firstName: String
    var lastName: String
    var username: String
    var email: String
    var phone: String
    var dateOfBirth: String
    var languageLevel: String
    var photo: String
}
