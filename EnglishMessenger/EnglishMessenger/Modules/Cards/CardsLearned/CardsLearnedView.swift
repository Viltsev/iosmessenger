//
//  CardsLearnedView.swift
//  EnglishMessenger
//
//  Created by Данила on 22.04.2024.
//

import SwiftUI

struct CardsLearnedView: View {
    @EnvironmentObject var router: MainNavigationRouter
    @StateObject private var viewModel: CardsLearnedViewModel = CardsLearnedViewModel()
    
    var body: some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                content()
            }
            .onAppear {
                viewModel.input.getLearnedCardsSubject.send()
            }
    }
}

extension CardsLearnedView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            customToolBar()
                .padding(.bottom, 50)
            switch viewModel.output.viewState {
            case .hasWords:
                learnedWords()
            case .nothingWords:
                nothingWords()
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
    
    @ViewBuilder
    func learnedWords() -> some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach(viewModel.output.learnedCards, id: \.id) { card in
                        HStack {
                            Image("checkmark")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding()
                            VStack(alignment: .leading) {
                                Text(card.text)
                                    .foregroundStyle(.mainPurple)
                                    .font(.custom("Montserrat-Bold", size: 20))
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                Text(card.explanation)
                                    .foregroundStyle(.mainPurple)
                                    .font(.custom("Montserrat-Light", size: 16))
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 10)
                            }
                            .padding(.vertical, 10)
                            Spacer()
                            Image("speaker")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .background(.lightPinky)
                        .cornerRadius(15)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 15)
                    }
                }
            }
        }
    }
}
