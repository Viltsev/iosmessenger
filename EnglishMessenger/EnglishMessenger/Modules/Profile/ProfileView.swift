//
//  ProfileView.swift
//  EnglishMessenger
//
//  Created by Данила on 17.02.2024.
//

import SwiftUI
import SDWebImageSwiftUI


struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject var mainRouter: MainNavigationRouter
    @EnvironmentObject var router: StartNavigationRouter
    
    var body: some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                profileBlock()
            }
            .onAppear {
                viewModel.input.friendsCountSubject.send()
            }
    }
}

extension ProfileView {
    @ViewBuilder
    func profileBlock() -> some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                VStack {
                    Image("profileEllipse")
                        .resizable()
                        .scaledToFit()
                        .ignoresSafeArea()
                        .overlay {
                            VStack {
                                Spacer()
                                HStack {
                                    profileButton(title: "Настройки", action: nil)
                                    Spacer()
                                    profileButton(title: "Выйти", action: logout)
                                }
                                .padding(.horizontal, 16)
                                GeometryReader { geometry in
                                    WebImage(url: viewModel.output.photo)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 200, height: 200)
                                        .cornerRadius(100)
                                        .background(
                                            Circle()
                                                .stroke(style: StrokeStyle(lineWidth: 2))
                                                .foregroundColor(.white)
                                        )
                                        .offset(x: geometry.size.width / 4, y: 40)
                                }
                            }
                        }
                    VStack(spacing: 15) {
                        HStack {
                            Text(viewModel.output.firstName)
                                .foregroundColor(.black)
                                .font(.custom("Montserrat-Regular", size: 35))
                            Text(viewModel.output.lastName)
                                .foregroundColor(.black)
                                .font(.custom("Montserrat-Regular", size: 35))
                        }
                        Text(viewModel.output.username)
                            .foregroundColor(.mainPurple)
                            .font(.custom("Montserrat-Light", size: 20))
                            .multilineTextAlignment(.center)
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 15) {
                                infoBlock(text: "День рождения:", value: viewModel.output.dateBirth, arrow: false)
                                infoBlock(text: "Уровень языка:", value: viewModel.output.languageLevel, arrow: false)
                                friendsButton(text: "Друзья:", value: viewModel.output.friendsCount)
                                infoBlock(text: "Интересы", value: "", arrow: true)
                            }
                        }
                    }
                    .padding(.top, 50)
                    
                    Spacer()
                }
            }
        
    }
    
    @ViewBuilder
    func infoBlock(text: String, value: String, arrow: Bool) -> some View {
        HStack {
            Text("\(text) \(value)")
                .foregroundColor(.mainPurple)
                .font(.custom("Montserrat-Light", size: 15))
                .padding(.horizontal, 15)
                .padding(.vertical, 20)
            Spacer()
            if arrow {
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 20)
            }
        }
        .frame(maxWidth: .infinity)
        .background(.white)
        .cornerRadius(15)
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    func friendsButton(text: String, value: Int) -> some View {
        Button {
            mainRouter.pushView(MainNavigation.pushFriendsView)
        } label: {
            HStack {
                Text("\(text) \(value)")
                    .foregroundColor(.mainPurple)
                    .font(.custom("Montserrat-Light", size: 15))
                    .padding(.horizontal, 15)
                    .padding(.vertical, 20)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 20)
            }
            .frame(maxWidth: .infinity)
            .background(.white)
            .cornerRadius(15)
            .padding(.horizontal, 16)
        }
    }
    
    @ViewBuilder
    func profileButton(title: String, action: (() -> Void)?) -> some View {
        Button {
            if let action = action {
                action()
            }
        } label: {
            Text(title)
                .foregroundColor(.mainPurple)
                .font(.custom("Montserrat-Light", size: 15))
        }
    }
}

extension ProfileView {
    func logout() {
        print(viewModel.output.photo ?? "non")
        viewModel.input.logoutSubject.send(router)
    }
}

#Preview {
    ProfileView()
}
