//
//  ExerciseTranslationView.swift
//  EnglishMessenger
//
//  Created by Данила on 01.05.2024.
//

import SwiftUI

struct ExerciseTranslationView: View {
    @EnvironmentObject var router: MainNavigationRouter
    @StateObject private var viewModel: ExerciseTranslationViewModel = ExerciseTranslationViewModel()
    
    var body: some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                content()
            }
            .onChange(of: viewModel.output.isGenerated) { oldValue, newValue in
                if newValue == true {
                    router.pushView(MainNavigation.pushTranslationView(viewModel.output.text))
                    viewModel.output.isGenerated.toggle()
                }
            }
    }
}

extension ExerciseTranslationView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            customToolBar()
            switch viewModel.output.state {
            case .loader:
                Spacer()
                GifImage(name: "pedro")
                    .frame(width: 250, height: 250)
                    .cornerRadius(125)
                    .background(
                        Circle()
                            .stroke(style: StrokeStyle(lineWidth: 2))
                            .foregroundColor(.mainPurple)
                    )
                Spacer()
            case .view:
                Spacer()
                TextField("Введи интересующую тебя тему текста...", text: $viewModel.output.topic)
                    .foregroundColor(.mainPurple)
                    .font(.custom("Montserrat-Light", size: 20))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                Spacer()
                generateButton()
                    .padding(.bottom, 15)
            }
            
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
            Text("Перевод текста")
                .foregroundStyle(.mainPurple)
                .font(.custom("Montserrat-ExtraBold", size: 18))
            Spacer()
        }
        .padding([.horizontal, .vertical], 16)
    }
    
    @ViewBuilder
    func generateButton() -> some View {
        Button {
            viewModel.output.state = .loader
            viewModel.input.generateTextSubject.send()
        } label: {
            VStack {
                Text("Сгенерировать текст")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-Bold", size: 20))
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
