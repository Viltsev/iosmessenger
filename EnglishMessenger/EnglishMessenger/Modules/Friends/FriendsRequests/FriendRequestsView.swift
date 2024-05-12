//
//  FriendRequestsView.swift
//  EnglishMessenger
//
//  Created by Данила on 12.05.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct FriendRequestsView: View {
    @StateObject private var viewModel: FriendRequestsViewModel = FriendRequestsViewModel()
    @EnvironmentObject var router: MainNavigationRouter
    
    var body: some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                content()
            }
            .onAppear {
                viewModel.output.state = .users
                viewModel.input.getRequestsSubject.send()
            }
    }
}

extension FriendRequestsView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            customToolBar()
                .padding(.bottom, 15)
            switch viewModel.output.state {
            case .users:
                requestsList()
                    .padding(.horizontal, 16)
            case .empty:
                Spacer()
                Text("Пока что нет заявок в друзья 🙃")
                    .foregroundStyle(.mainPurple)
                    .font(.custom("Montserrat-ExtraBold", size: 20))
                    .padding(.horizontal, 16)
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
            Text("Заявки в друзья")
                .foregroundStyle(.mainPurple)
                .font(.custom("Montserrat-ExtraBold", size: 20))
            Spacer()
        }
        .padding([.horizontal, .vertical], 16)
    }
    
    @ViewBuilder
    func requestsList() -> some View {
        List(viewModel.output.requestsList, id: \.id) { user in
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
            }
            .swipeActions {
                Button {
                    viewModel.input.acceptRequestSubject.send(user.email)
                    viewModel.input.deleteRequestSubject.send(user.id)
                } label: {
                    Text("Добавить")
                        .font(.custom("Montserrat-Bold", size: 10))
                        .foregroundStyle(.white)
                }
                .tint(.mainPurple)
                Button {
                    viewModel.input.rejectRequestSubject.send(user.email)
                    viewModel.input.deleteRequestSubject.send(user.id)
                } label: {
                    Text("Отклонить")
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
