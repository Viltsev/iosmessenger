//
//  FriendsView.swift
//  EnglishMessenger
//
//  Created by Данила on 12.05.2024.
//

import SwiftUI

struct FriendsView: View {
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
                .padding(.bottom, 30)
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
    
}
