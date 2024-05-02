//
//  TranslationCheckView.swift
//  EnglishMessenger
//
//  Created by Данила on 02.05.2024.
//

import SwiftUI

struct TranslationCheckView: View {
    @EnvironmentObject var router: MainNavigationRouter
    @StateObject var viewModel: TranslationCheckViewModel
    
    var body: some View {
        Color.mainPurple
            .ignoresSafeArea()
            .overlay {
                content()
            }
    }
}

extension TranslationCheckView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    info(title: "Текст", description: viewModel.output.text)
                    info(title: "Твой ответ", description: viewModel.output.translation)
                    if let checkedTranslation = viewModel.output.checkedTranslation {
                        info(title: "Исправленный перевод", description: checkedTranslation.correctedText)
                        infoExplanation(explanation: checkedTranslation.explanations)
                    }
                }
            }
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
    func info(title: String, description: String) -> some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .foregroundStyle(.mainPurple)
                        .font(.custom("Montserrat-Bold", size: 20))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                    Spacer()
                }
                
                HStack {
                    Text(description)
                        .foregroundStyle(.black)
                        .font(.custom("Montserrat-Regular", size: 15))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
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
    
    @ViewBuilder
    func infoExplanation(explanation: [String]) -> some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Объяснение")
                        .foregroundStyle(.mainPurple)
                        .font(.custom("Montserrat-Bold", size: 20))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                    Spacer()
                }
                
                VStack(spacing: 10) {
                    ForEach(explanation, id: \.self) { explanation in
                        HStack {
                            Text("• \(explanation)")
                                .foregroundStyle(.black)
                                .font(.custom("Montserrat-Regular", size: 15))
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.vertical, 10)
                
            }
            .padding(.vertical, 10)
        }
        .frame(maxWidth: .infinity)
        .background(.white)
        .cornerRadius(15)
        .padding(.horizontal, 16)
        .padding(.bottom, 15)
    }
}
