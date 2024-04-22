//
//  CardsLearnedView.swift
//  EnglishMessenger
//
//  Created by Данила on 22.04.2024.
//

import SwiftUI

struct CardsLearnedView: View {
    @EnvironmentObject var router: MainNavigationRouter
    
    var body: some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                content()
            }
    }
}

extension CardsLearnedView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            customToolBar()
                .padding(.bottom, 50)
            nothingWords()
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
            Text("Выучено")
                .foregroundStyle(.mainPurple)
                .font(.custom("Montserrat-ExtraBold", size: 24))
            Spacer()
        }
        .padding([.horizontal, .vertical], 16)
    }
    
    @ViewBuilder
    func nothingWords() -> some View {
        VStack {
            Image("hedgehog")
                .resizable()
                .scaledToFill()
                .frame(width: 250, height: 250)
                .padding(.vertical, 25)
            Text("Пока ничего не выучено 😔")
                .foregroundStyle(.mainPurple)
                .font(.custom("Montserrat-Bold", size: 20))
                .padding(.bottom, 15)
            Text("Продолжайте изучение!")
                .foregroundStyle(.lightPurple)
                .font(.custom("Montserrat-Bold", size: 20))
        }
    }
}
