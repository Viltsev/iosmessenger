//
//  ExerciseMainView.swift
//  EnglishMessenger
//
//  Created by Данила on 01.05.2024.
//

import SwiftUI

struct ExerciseMainView: View {
    @EnvironmentObject var router: MainNavigationRouter
    
    var body: some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                content()
            }
    }
}

extension ExerciseMainView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            HStack {
                Image("darkPurpleBlob")
                    .imageScale(.small)
                    .overlay {
                        Text("Упражнения")
                            .foregroundStyle(.white)
                            .font(.custom("Montserrat-Regular", size: 28))
                    }
                Spacer()
            }
            .padding(.bottom, 20)
            menu()
            Spacer()
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
    func menu() -> some View {
        VStack(spacing: 20) {
            infoBlock(title: "Грамматический тренинг", description: "Вставь пропущенное слово/словосочетание, используя грамматические правила")
            infoBlock(title: "Ответ на вопрос", description: "Ответь на случайный вопрос и проверь свой ответ на корректность")
            infoBlock(title: "Перевод текста", description: "Переведи предложенный текст и проверь свой перевод на наличие ошибок")
        }
    }
    
    @ViewBuilder
    func infoBlock(title: String, description: String) -> some View {
        Button {
            
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(title)
                            .foregroundStyle(.mainPurple)
                            .font(.custom("Montserrat-Regular", size: 20))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 15)
                        Spacer()
                    }
                    
                    HStack {
                        Text(description)
                            .foregroundStyle(.mainPurple)
                            .font(.custom("Montserrat-Light", size: 15))
                            .padding(.horizontal, 20)
                            .padding(.bottom, 15)
                        Spacer()
                    }
                    
                }
                .padding(.vertical, 10)
            }
            .frame(maxWidth: .infinity)
            .background(.white)
            .cornerRadius(15)
            .padding(.horizontal, 16)
            .padding(.bottom, 15)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
