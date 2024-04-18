//
//  ChatsSearcherFieldStyle.swift
//  EnglishMessenger
//
//  Created by Данила on 18.04.2024.
//

import SwiftUI

struct ChatsSearcherFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFill()
                .frame(width: 20, height: 20)
                .padding(.vertical, 8)
                .padding(.leading, 16)
            configuration
                .padding(.vertical, 8)
                .padding(.horizontal, 8)
                .background(.profilePinky)
                .cornerRadius(20)
        }
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.lightPurple, lineWidth: 1)
            )
    }
}

