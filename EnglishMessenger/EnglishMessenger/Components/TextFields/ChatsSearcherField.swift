//
//  ChatsSearcherField.swift
//  EnglishMessenger
//
//  Created by Данила on 18.04.2024.
//

import SwiftUI

struct ChatsSearcherField: View {
    var textFieldLabel: String
    var text: Binding<String>
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(textFieldLabel, text: text)
                .textFieldStyle(ChatsSearcherFieldStyle())
                .foregroundColor(.mainPurple)
                .font(.custom("Montserrat-Light", size: 18))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}
