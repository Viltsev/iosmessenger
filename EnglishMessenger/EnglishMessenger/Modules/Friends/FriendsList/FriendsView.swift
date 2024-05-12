//
//  FriendsView.swift
//  EnglishMessenger
//
//  Created by Данила on 12.05.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct FriendsView: View {
    @StateObject private var viewModel: FriendsViewModel = FriendsViewModel()
    @EnvironmentObject var router: MainNavigationRouter
    
    var body: some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                content()
            }
            .onAppear {
                viewModel.input.getFriendsSubject.send()
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
                .padding(.bottom, 20)
            
            switch viewModel.output.state {
            case .friends:
                mainScreen()
            case .search:
                searchScreen()
            }
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
            FriendsSearcherField(textFieldLabel: "Поиск", text: $viewModel.output.searchedFriend)
                .onTapGesture {
                    withAnimation(.bouncy) {
                        viewModel.input.changeCurrentScreenSubject.send(.search)
                        viewModel.output.searchedFriend.append("@")
                    }
                }
                .onSubmit {
                    viewModel.input.findUserByUsernameSubject.send(viewModel.output.searchedFriend)
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
    
    @ViewBuilder
    func searchScreen() -> some View {
        List(viewModel.output.findedUsers, id: \.id) { user in
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
                    Text("\(user.firstName) \(user.lastName)")
                        .font(.custom("Montserrat-Regular", size: 15))
                        .foregroundStyle(.mainPurple)
                        .padding(.top, 5)
                    Text(user.username)
                        .font(.custom("Montserrat-Light", size: 15))
                        .foregroundStyle(.lightPurple)
                        .padding(.top, 3)
                        .padding(.bottom, 5)
                }
                
                .padding(.horizontal, 15)
                Spacer()
                Button {
                    viewModel.input.addingFriendViewSubject.send(user.id)
                    viewModel.input.addingFriendSubject.send(user.email)
                } label: {
                    Image(systemName: user.isRequested ? "checkmark.circle" : "plus.circle")
                        .resizable()
                        .scaledToFill()
                        .foregroundStyle(.mainPurple)
                        .frame(width: 20, height: 20)
                        .padding(.horizontal, 5)
                }
            }
        }
        .background(Color.profilePinky)
        .listStyle(.sidebar)
        .scrollContentBackground(.hidden)
    }
    
    @ViewBuilder
    func mainScreen() -> some View {
        VStack {
            friendsRequests()
            myFriends()
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    func friendsRequests() -> some View {
        VStack {
            Divider()
            Button {
                router.pushView(MainNavigation.pushFriendsRequestsView)
            } label: {
                HStack {
                    Image(systemName: "person.2.fill")
                        .resizable()
                        .scaledToFill()
                        .foregroundStyle(.mainPurple)
                        .frame(width: 20, height: 20)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 8)
                    Text("Заявки в друзья")
                        .font(.custom("Montserrat-Bold", size: 15))
                        .foregroundStyle(.mainPurple)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 15)
                    Spacer()
                }
            }
            Divider()
        }
    }
    
    @ViewBuilder
    func myFriends() -> some View {
        VStack {
            HStack {
                Text("Мои друзья")
                    .font(.custom("Montserrat-Bold", size: 15))
                    .foregroundStyle(.mainPurple)
                    .padding(.vertical, 10)
                Spacer()
            }
            List(viewModel.output.friendsList, id: \.id) { user in
                HStack {
                    WebImage(url: URL(string: user.photo))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .cornerRadius(25)
                        .background(
                            Circle()
                                .stroke(style: StrokeStyle(lineWidth: 2))
                                .foregroundColor(.white)
                        )
                        .padding(.trailing, 10)
                    VStack(alignment: .leading) {
                        Text("\(user.firstName) \(user.lastName)")
                            .font(.custom("Montserrat-Regular", size: 15))
                            .foregroundStyle(.mainPurple)
                            .padding(.top, 5)
                        Text("\(FormatDate.getFormatDate(user.dateOfBirth)),  \(user.languageLevel)")
                            .font(.custom("Montserrat-Light", size: 15))
                            .foregroundStyle(.lightPurple)
                            .padding(.top, 3)
                            .padding(.bottom, 5)
                    }
                    Spacer()
                    Button {
                        print("go to message")
                    } label: {
                        Image(systemName: "message")
                            .resizable()
                            .scaledToFill()
                            .foregroundStyle(.mainPurple)
                            .frame(width: 20, height: 20)
                            .padding(.horizontal, 5)
                    }
                }
                .swipeActions {
                    Button {
                        
                    } label: {
                        Text("Удалить из друзей")
                            .font(.custom("Montserrat-Bold", size: 10))
                            .foregroundStyle(.white)
                    }
                    .tint(.red)
                }
            }
            .padding(.horizontal, -16)
            .background(Color.profilePinky)
            .listStyle(.sidebar)
            .scrollContentBackground(.hidden)
        }
    }
}
