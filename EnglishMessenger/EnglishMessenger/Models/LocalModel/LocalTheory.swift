//
//  LocalTheory.swift
//  EnglishMessenger
//
//  Created by Данила on 28.04.2024.
//

import Foundation

struct LocalTheory: Identifiable {
    let id: Int
    let categories: [LocalCategory]
}

struct LocalCategory: Identifiable, Hashable {
    let id: Int
    let title: String
    let description: String
    let topics: [LocalTopic]
    let theoryList: [LocalTheoryList]
}

struct LocalTopic: Identifiable, Hashable {
    let id: Int
    let title: String
    let description: String
    let theoryList: [LocalTheoryList]
    let subtopicList: [LocalSubtopicList]
}

struct LocalTheoryList: Identifiable, Hashable {
    let id: Int
    let title: String
    let level: String
    let explanation: String
    let example: String
    let commonMistakeDescription: String
    let cmWrong: String
    let cmRight: String
}

struct LocalSubtopicList: Identifiable, Hashable {
    let id: Int
    let title: String
    let description: String
    let theoryList: [LocalTheoryList]
}
