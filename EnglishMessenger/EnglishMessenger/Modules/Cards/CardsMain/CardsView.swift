//
//  CardsView.swift
//  EnglishMessenger
//
//  Created by Данила on 22.04.2024.
//

import SwiftUI

struct CardsView: View {
    @EnvironmentObject var router: MainNavigationRouter
    @StateObject private var viewModel: CardsViewModel = CardsViewModel()
    
    var body: some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                content()
            }
            .onAppear {
                viewModel.input.getLearnedCardsSubject.send()
                viewModel.input.getToLearnCardsSubject.send()
            }
    }
}

extension CardsView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            HStack {
                Image("darkPurpleBlob")
                    .imageScale(.small)
                    .overlay {
                        Text("Карточки")
                            .foregroundStyle(.white)
                            .font(.custom("Montserrat-Regular", size: 35))
                    }
                Spacer()
            }
            .padding(.bottom, 20)
            contentInfo()
            Spacer()
            buttonLearn()
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    router.popView()
                } label: {
                    Image(systemName: "multiply")
                        .font(.title3)
                        .bold()
                }
            }
        })
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func contentInfo() -> some View {
        VStack {
            contentLearned()
            contentStillLearn()
        }
        .padding(.vertical, 30)
    }
    
    @ViewBuilder
    func contentLearned() -> some View {
        Button {
            router.pushView(MainNavigation.pushCardsLearned)
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Image("checkmark")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding()
                    Text("Выучено слов")
                        .foregroundStyle(.mainPurple)
                        .font(.custom("Montserrat-Bold", size: 24))
                        .padding(.horizontal, 20)
                        .padding(.bottom, 15)
                }
                .padding(.vertical, 10)
                Spacer()
                Text("\(viewModel.output.learnedCards.count)")
                    .foregroundStyle(.mainPurple)
                    .font(.custom("Montserrat-Bold", size: 36))
                    .padding(.horizontal, 15)
            }
            .frame(maxWidth: .infinity)
            .background(.lightPinky)
            .cornerRadius(15)
            .padding(.horizontal, 16)
            .padding(.bottom, 15)
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    @ViewBuilder
    func contentStillLearn() -> some View {
        Button {
            router.pushView(MainNavigation.pushCardsLearning)
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Image("brain")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding()
                    Text("Изучаю")
                        .foregroundStyle(.white)
                        .font(.custom("Montserrat-Bold", size: 24))
                        .padding(.horizontal, 20)
                        .padding(.bottom, 15)
                }
                .padding(.vertical, 10)
                Spacer()
                Text("\(viewModel.output.toLearnCards.count)")
                    .foregroundStyle(.white)
                    .font(.custom("Montserrat-Bold", size: 36))
                    .padding(.horizontal, 15)
            }
            .frame(maxWidth: .infinity)
            .background(.lightPurple)
            .cornerRadius(15)
            .padding(.horizontal, 16)
            .padding(.bottom, 15)
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    @ViewBuilder
    func buttonLearn() -> some View {
        Button {
            router.pushView(MainNavigation.pushCardsSets)
        } label: {
            VStack {
                Text("Учить")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-Bold", size: 24))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 20)
            }
            .frame(maxWidth: .infinity)
            .background (
                RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                    .foregroundColor(.mainPurple)
            )
        }
        .buttonStyle(ScaleButtonStyle())
        .padding(.horizontal, 16)
    }
}
