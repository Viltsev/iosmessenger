//
//  GrammarTrainingView.swift
//  EnglishMessenger
//
//  Created by Данила on 01.05.2024.
//

import SwiftUI

struct GrammarTrainingView: View {
    @EnvironmentObject var router: MainNavigationRouter
    @State private var theme: String = ""
    
    var body: some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                content()
            }
    }
}

extension GrammarTrainingView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            customToolBar()
                .padding(.bottom, 30)
            grammarTraining()
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
            Text("Грамматический тренинг")
                .foregroundStyle(.mainPurple)
                .font(.custom("Montserrat-ExtraBold", size: 18))
            Spacer()
        }
        .padding([.horizontal, .vertical], 16)
    }
    
    @ViewBuilder
    func grammarTraining() -> some View {
        VStack {
            Text("Выбери необходимую тебе тему в разделе “Теория” и пройди упражнения после ознакомления с краткой грамматической справкой ")
                .foregroundStyle(.mainPurple)
                .font(.custom("Montserrat-Regular", size: 15))
                .padding(.bottom, 20)
            Text("ИЛИ")
                .foregroundStyle(.mainPurple)
                .font(.custom("Montserrat-Bold", size: 16))
                .padding(.bottom, 20)
            TextField("Введи интересующую тебя тему...", text: $theme)
                .foregroundColor(.mainPurple)
                .font(.custom("Montserrat-Light", size: 16))
                .multilineTextAlignment(.center)
            Spacer()
            Image("kitty_training")
                .resizable()
                .scaledToFill()
                .frame(width: 250, height: 250)
                .padding(.vertical, 25)
            Spacer()
            buttonLearn()
                .padding(.bottom, 15)
        }
    }
    
    @ViewBuilder
    func buttonLearn() -> some View {
        Button {
//            router.pushView(MainNavigation.pushCardsSets)
        } label: {
            VStack {
                Text("Перейти к упражнениям")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-Bold", size: 16))
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
