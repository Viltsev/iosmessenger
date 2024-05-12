//
//  FriendsSearcherField.swift
//  EnglishMessenger
//
//  Created by Данила on 12.05.2024.
//

import SwiftUI
import Combine

struct FriendsSearcherField: View {
    var textFieldLabel: String
    var text: Binding<String>
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(textFieldLabel, text: text)
                .textFieldStyle(ChatsSearcherFieldStyle())
                .foregroundColor(.mainPurple)
                .font(.custom("Montserrat-Light", size: 18))
        }
    }
}
