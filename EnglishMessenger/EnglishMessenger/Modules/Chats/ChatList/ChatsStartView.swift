//
//  ChatsStartView.swift
//  EnglishMessenger
//
//  Created by Данила on 15.04.2024.
//

import SwiftUI
import SDWebImageSwiftUI

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
            ChatsSearcherField(textFieldLabel: "Find user...", text: $viewModel.output.findUserText, action: viewModel.input.findCompanionSubject)
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
        List(viewModel.output.userChatsUsers, id: \.id) { user in
            Button {
                router.pushView(MainNavigation.pushChatView(user))
            } label: {
                HStack {
                    WebImage(url: URL(string: user.photo))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .cornerRadius(35)
                        .background(
                            Circle()
                                .stroke(style: StrokeStyle(lineWidth: 2))
                                .foregroundColor(.white)
                        )
                    
                    VStack(alignment: .leading) {
                        Text(user.username)
                            .font(.headline)
                            .foregroundStyle(.mainPurple)
                            .padding(.vertical, 5)
                            
                        Text(viewModel.findLastMessage(user))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.vertical, 5)
                    }
                    .padding(.horizontal, 15)
                    
                }
            }
            .contextMenu {
                Button {
                    viewModel.deleteChat(user.email)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .background(Color.profilePinky)
        .listStyle(.sidebar)
        .scrollContentBackground(.hidden)
    }
    
    @ViewBuilder
    func searchedUser() -> some View {
        List(viewModel.output.findedUsers, id: \.id) { user in
            Button {
                router.pushView(MainNavigation.pushChatView(user))
            } label: {
                HStack {
                    WebImage(url: URL(string: user.photo))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .cornerRadius(35)
                        .background(
                            Circle()
                                .stroke(style: StrokeStyle(lineWidth: 2))
                                .foregroundColor(.white)
                        )
                    
                    VStack(alignment: .leading) {
                        Text(user.username)
                            .font(.headline)
                            .foregroundStyle(.mainPurple)
                            .padding(.vertical, 5)
                            
                        Text(viewModel.findLastMessage(user))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.vertical, 5)
                    }
                    .padding(.horizontal, 15)
                    
                }
            }
        }
        .background(Color.profilePinky)
        .listStyle(.sidebar)
        .scrollContentBackground(.hidden)
    }
}
