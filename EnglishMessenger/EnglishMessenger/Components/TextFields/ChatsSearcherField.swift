//
//  ChatsSearcherField.swift
//  EnglishMessenger
//
//  Created by Данила on 18.04.2024.
//

import SwiftUI
import Combine

struct ChatsSearcherField: View {
    var textFieldLabel: String
    var text: Binding<String>
    var action: PassthroughSubject<Void, Never>?
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(textFieldLabel, text: text)
                .textFieldStyle(ChatsSearcherFieldStyle())
                .foregroundColor(.mainPurple)
                .font(.custom("Montserrat-Light", size: 18))
                .contextMenu {
                    Button {
                       buttonAction()
                    } label: {
                        Label("Find companion", systemImage: "person.badge.plus")
                    }
                }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
    
    private func buttonAction() {
        if let action = action {
            action.send()
        }
    }
}
