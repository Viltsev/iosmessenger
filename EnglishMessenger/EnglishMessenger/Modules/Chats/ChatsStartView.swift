//
//  ChatsStartView.swift
//  EnglishMessenger
//
//  Created by Данила on 15.04.2024.
//

import SwiftUI

struct ChatsStartView: View {
    @StateObject private var viewModel: ChatsStartViewModel = ChatsStartViewModel()
    @EnvironmentObject var router: MainNavigationRouter
    
    var body: some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                chatsMain()
            }
    }
}

extension ChatsStartView {
    @ViewBuilder
    func chatsMain() -> some View {
        VStack {
            HStack {
                CustomTextField(textFieldLabel: "Find user...", text: $viewModel.output.findUserText)
                    .padding(.vertical, 25)
                Button {
                    viewModel.input.findAllUsers.send()
                } label: {
                    Text("Search")
                        .foregroundStyle(Color.mainPurple)
                }
            }
            .padding(.horizontal, 25)
            searchedUsers()
            Spacer()
        }
    }
    
    @ViewBuilder
    func searchedUsers() -> some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach(viewModel.output.mockUsers, id: \.id) { user in
                        Button {
                            router.pushView(MainNavigation.pushChatView(user))
                        } label: {
                            VStack {
                                Text(user.email)
                                    .font(.title2)
                                    .foregroundStyle(.mainPurple)
                                    .padding(.vertical, 15)
                            }
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .cornerRadius(15)
                            .padding(.horizontal, 25)
                        }
                    }
                }
            }
        }
    }
}
