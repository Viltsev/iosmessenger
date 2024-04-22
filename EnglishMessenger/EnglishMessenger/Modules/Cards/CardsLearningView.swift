//
//  CardsLearningView.swift
//  EnglishMessenger
//
//  Created by Данила on 22.04.2024.
//

import SwiftUI

struct CardsLearningView: View {
    @EnvironmentObject var router: MainNavigationRouter
    
    var body: some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                content()
            }
    }
}

extension CardsLearningView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            customToolBar()
                .padding(.bottom, 30)
            addWord()
            Spacer()
            nothingToLearn()
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
            Text("Изучаю")
                .foregroundStyle(.mainPurple)
                .font(.custom("Montserrat-ExtraBold", size: 24))
            Spacer()
        }
        .padding([.horizontal, .vertical], 16)
    }
    
    @ViewBuilder
    func addWord() -> some View {
        Button {
            
        } label: {
            HStack {
                Image("add")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding()
                Spacer()
                Text("Добавить слово")
                    .foregroundColor(.mainPurple)
                    .font(.custom("Montserrat-Bold", size: 24))
                    .padding(.horizontal, 15)
                    .padding(.vertical, 20)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(.white)
            .cornerRadius(15)
            .padding(.horizontal, 16)
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    @ViewBuilder
    func nothingToLearn() -> some View {
        Text("Добавьте слова для их изучения")
            .foregroundStyle(.mainPurple)
            .font(.custom("Montserrat-Bold", size: 20))
            .multilineTextAlignment(.center)
            .padding()
    }
}
