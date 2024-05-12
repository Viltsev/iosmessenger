//
//  FriendsView.swift
//  EnglishMessenger
//
//  Created by Данила on 12.05.2024.
//

import SwiftUI

struct FriendsView: View {
    @StateObject private var viewModel: FriendsViewModel = FriendsViewModel()
    @EnvironmentObject var router: MainNavigationRouter
    
    var body: some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                content()
            }
    }
}

extension FriendsView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            customToolBar()
                .padding(.bottom, 15)
            searchBar()
            Spacer()
        }
    }
    
    @ViewBuilder
    func customToolBar() -> some View {
        HStack {
            Button {
                router.popView()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(.mainPurple)
                    .font(.title3)
                    .bold()
            }
            Spacer()
            Text("Друзья")
                .foregroundStyle(.mainPurple)
                .font(.custom("Montserrat-ExtraBold", size: 20))
            Spacer()
        }
        .padding([.horizontal, .vertical], 16)
    }
    
    @ViewBuilder
    func searchBar() -> some View {
        HStack {
            FriendsSearcherField(textFieldLabel: "Поиск друга...", text: $viewModel.output.searchedFriend)
                .onTapGesture {
                    withAnimation(.bouncy) {
                        viewModel.input.changeCurrentScreenSubject.send(.search)
                        viewModel.output.searchedFriend.append("@")
                    }
                }
                .onSubmit {
//                    viewModel.input.findUserByUsernameSubject.send(viewModel.output.findUserText)
                }
                .padding(.vertical, 10)
            if viewModel.output.state == .search {
                Button {
                    withAnimation(.bouncy) {
                        viewModel.input.changeCurrentScreenSubject.send(.friends)
                        viewModel.output.searchedFriend = ""
                    }
                } label: {
                    Text("Отмена")
                        .foregroundStyle(Color.mainPurple)
                        .font(.custom("Montserrat-Light", size: 15))
                }
            }
        }
        .padding(.horizontal, 16)
    }
}
