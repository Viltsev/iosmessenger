//
//  EducationView.swift
//  EnglishMessenger
//
//  Created by Данила on 22.04.2024.
//

import SwiftUI

struct EducationView: View {
    @EnvironmentObject var router: MainNavigationRouter
    
    var body: some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                content()
            }
    }
}

extension EducationView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            HStack {
                Image("lightPinkBlob")
                    .imageScale(.small)
                    .overlay {
                        Text("Обучение")
                            .foregroundStyle(.mainPurple)
                            .font(.custom("Montserrat-Regular", size: 35))
                    }
                Spacer()
            }
            .padding(.bottom, 20)
            contentScroll()
            Spacer()
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func contentScroll() -> some View {
        VStack {
            cardsView(title: "Карточки", description: "Изучай и повторяй новые слова и выражения", action: goToCards)
            cardsView(title: "Теория", description: "Краткие справки по основным грамматическим темам", action: goToTheory)
            cardsView(title: "Упражнения", description: "Практикуйся в применении изученного материала", action: goToExercises)
        }
        
    }
    
    @ViewBuilder
    func cardsView(title: String, description: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .font(.custom("Montserrat-Regular", size: 24))
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    Text(description)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .font(.custom("Montserrat-Light", size: 16))
                        .padding(.bottom, 20)
                }
                .padding(.horizontal, 16)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(.white)
            .cornerRadius(15)
            .padding(.horizontal, 16)
            .padding(.bottom, 15)
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    func goToCards() {
        router.pushView(MainNavigation.pushCardsView)
    }
    
    func goToTheory() {
        router.pushView(MainNavigation.pushTheoryMainView)
    }
    
    func goToExercises() {
        router.pushView(MainNavigation.pushExerciseMainView)
    }
}
