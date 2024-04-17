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
                VStack {
                    searchBar()
                    switch viewModel.output.currentScreen {
                    case .chats:
                        chatsScreen()
                    case .search:
                        searchScreen()
                    }
                    Spacer()
                }
            }
            .onAppear {
                viewModel.input.fetchAllChatsSubject.send()
            }
    }
}

extension ChatsStartView {
    @ViewBuilder
    func searchBar() -> some View {
        HStack {
            CustomTextField(textFieldLabel: "Find user...", text: $viewModel.output.findUserText)
                .onTapGesture {
                    withAnimation(.bouncy) {
                        viewModel.input.changeCurrentScreenSubject.send(.search)
                        viewModel.output.findUserText.append("@")
                    }
                }
                .onSubmit {
                    viewModel.input.findUserByUsernameSubject.send(viewModel.output.findUserText)
                }
                .padding(.vertical, 10)
            if viewModel.output.currentScreen == .search {
                Button {
                    withAnimation(.bouncy) {
                        viewModel.input.changeCurrentScreenSubject.send(.chats)
                        viewModel.output.findUserText = ""
                    }
                } label: {
                    Text("Cancel")
                        .foregroundStyle(Color.mainPurple)
                }
            }
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    func chatsScreen() -> some View {
        searchedChats()
    }
    
    @ViewBuilder
    func searchScreen() -> some View {
        searchedUser()
    }
    
    @ViewBuilder
    func searchedChats() -> some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach(viewModel.output.userChatsUsers, id: \.id) { user in
                        Button {
                            router.pushView(MainNavigation.pushChatView(user))
                        } label: {
                            VStack {
                                Text(user.email)
                                    .font(.title)
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
    
    @ViewBuilder
    func searchedUser() -> some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach(viewModel.output.findedUsers, id: \.id) { user in
                        Button {
                            router.pushView(MainNavigation.pushChatView(user))
                        } label: {
                            VStack {
                                Text(user.email)
                                    .font(.title)
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
