//
//  SearchChatView.swift
//  EnglishMessenger
//
//  Created by Данила on 17.04.2024.
//

import SwiftUI
import Combine

struct SearchChatView: View {
    var changeCurrentScreenSubject: PassthroughSubject<CurrentScreen, Never>? = nil
    @State var text = ""
    
    var body: some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                searchView()
            }
    }
}

extension SearchChatView {
    @ViewBuilder
    func searchView() -> some View {
        VStack {
            HStack {
                CustomTextField(textFieldLabel: "Find user...", text: $text)
                    .padding(.vertical, 5)
                Button {
                    backButtonAction()
                } label: {
                    Text("Back")
                        .foregroundStyle(Color.mainPurple)
                }
            }
            .padding(.horizontal, 16)
            Spacer()
        }
        Text("search view")
            .font(.largeTitle)
    }
}

extension SearchChatView {
    private func backButtonAction() {
        if let screenSubject = changeCurrentScreenSubject {
            screenSubject.send(.chats)
        }
    }
}
