//
//  ExerciseQuestionView.swift
//  EnglishMessenger
//
//  Created by Данила on 01.05.2024.
//

import SwiftUI

struct ExerciseQuestionView: View {
    @EnvironmentObject var router: MainNavigationRouter
    
    var body: some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                content()
            }
    }
}

extension ExerciseQuestionView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            customToolBar()
            Spacer()
            Button {
                
            } label: {
                Text("Сгенерировать вопрос")
                    .foregroundStyle(.mainPurple)
                    .font(.custom("Montserrat-Bold", size: 24))
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
            Text("Ответ на вопрос")
                .foregroundStyle(.mainPurple)
                .font(.custom("Montserrat-ExtraBold", size: 18))
            Spacer()
        }
        .padding([.horizontal, .vertical], 16)
    }
}
