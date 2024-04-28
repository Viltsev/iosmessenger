//
//  TheoryCardView.swift
//  EnglishMessenger
//
//  Created by Данила on 29.04.2024.
//

import SwiftUI

struct TheoryCardView: View {
    @EnvironmentObject var router: MainNavigationRouter
    @StateObject var viewModel: TheoryCardViewModel
    
    var body: some View {
        Color.lightPurple
            .ignoresSafeArea()
            .overlay {
                content()
            }
    }
}

extension TheoryCardView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            if let card = viewModel.output.theory {
                theoryCard(card: card)
            }
            Spacer()
            exerciseButton()
                .padding(.vertical, 15)
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    router.popView()
                } label: {
                    Image(systemName: "multiply")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .bold()
                }
            }
        })
    }
    
    @ViewBuilder
    func theoryCard(card: LocalTheoryList) -> some View {
        VStack {
            HStack {
                Text(card.title)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .font(.custom("Montserrat-Bold", size: 20))
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 10) {
                    HStack {
                        Text("Explanation")
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .font(.custom("Montserrat-SemiBold", size: 20))
                        Spacer()
                    }
                    HStack {
                        Text(card.explanation)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .font(.custom("Montserrat-Regular", size: 14))
                        Spacer()
                    }
                    HStack {
                        Text("Example")
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .font(.custom("Montserrat-SemiBold", size: 20))
                        Spacer()
                    }
                    HStack {
                        Text(card.example)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .font(.custom("Montserrat-Regular", size: 14))
                        Spacer()
                    }
                    HStack {
                        Text("Common mistakes")
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .font(.custom("Montserrat-SemiBold", size: 20))
                        Spacer()
                    }
                    HStack {
                        Text(card.commonMistakeDescription)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .font(.custom("Montserrat-Regular", size: 14))
                        Spacer()
                    }
                    HStack {
                        Image("notCorrect")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(card.cmWrong)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .font(.custom("Montserrat-Regular", size: 14))
                        Spacer()
                    }
                    HStack {
                        Image("checkmark")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(card.cmRight)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .font(.custom("Montserrat-Regular", size: 14))
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(.profilePinky)
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding(.horizontal, 16)
        .padding(.bottom, 15)
    }
    
    @ViewBuilder
    func exerciseButton() -> some View {
        Button {
            // todo: go to exercises
        } label: {
            Text("Упражнения")
                .foregroundStyle(.white)
                .font(.custom("Montserrat-Bold", size: 24))
        }
    }
}
