//
//  FormatDate.swift
//  EnglishMessenger
//
//  Created by Данила on 13.03.2024.
//

import Foundation

struct FormatDate {
    static func formatDate(dateOfBirth: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateString = dateOfBirth
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "dd.MM.yyyy"
            
            let formattedDateString = dateFormatter.string(from: date)
            UserDefaults.standard.setValue(formattedDateString, forKey: "dateOfBirth")
        } else {
            print("Невозможно преобразовать строку в дату")
        }
    }
}
