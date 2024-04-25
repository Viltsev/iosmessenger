//
//  CardsSetView.swift
//  EnglishMessenger
//
//  Created by Данила on 24.04.2024.
//

import SwiftUI

struct CardsSetView: View {
    @EnvironmentObject var router: MainNavigationRouter
    var set: LocalCardSet
    
    var body: some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                content()
            }
    }
}

extension CardsSetView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            customToolBar()
                .padding(.bottom, 25)
            HStack {
                Text(self.set.title)
                    .foregroundStyle(.mainPurple)
                    .font(.custom("Montserrat-ExtraBold", size: 36))
                Spacer()
            }
            .padding(.horizontal, 16)
            wordsView()
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
        }
        .padding([.horizontal, .vertical], 16)
    }
    
    @ViewBuilder
    func wordsView() -> some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(self.set.cardList, id: \.id) { card in
                        wordView(word: card.text ?? "", translation: card.explanation ?? "")
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 30)
            buttonsView()
                .padding(.horizontal, 16)
        }
    }
    
    @ViewBuilder
    func wordView(word: String, translation: String) -> some View {
        HStack {
            Spacer()
            VStack(alignment: .center) {
                Text(word)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .font(.custom("Montserrat-Bold", size: 32))
                    .padding(.top, 35)
                    .padding(.bottom, 15)
                Text(translation)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .font(.custom("Montserrat-Regular", size: 16))
                    .padding(.bottom, 35)
            }
            .padding(.horizontal, 80)
            .padding(.vertical, 40)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(.lightPurple)
        .cornerRadius(5)
        .padding(.bottom, 15)
    }
    
    @ViewBuilder
    func buttonsView() -> some View {
        VStack(spacing: 20) {
            buttonView(text: "Карточки")
            buttonView(text: "Тест")
                .disabled(true)
            buttonView(text: "Совоставить")
                .disabled(true)
        }
    }
    
    @ViewBuilder
    func buttonView(text: String) -> some View {
        Button {
            router.pushView(MainNavigation.pushCardView(self.set.toLearn))
        } label: {
            VStack {
                Text(text)
                    .foregroundColor(.mainPurple)
                    .font(.custom("Montserrat-Bold", size: 24))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 20)
            }
            .frame(maxWidth: .infinity)
            .background (
                roundedRectangle()
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    @ViewBuilder
    func roundedRectangle() -> some View {
        RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
            .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
            .foregroundColor(.mainPurple)
    }
}

//#Preview {
//    CardsSetView()
//}
