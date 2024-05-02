//
//  ExerciseQuestionView.swift
//  EnglishMessenger
//
//  Created by Данила on 01.05.2024.
//

import SwiftUI

struct ExerciseQuestionView: View {
    @EnvironmentObject var router: MainNavigationRouter
    @StateObject private var viewModel: ExerciseQuestionViewModel = ExerciseQuestionViewModel()
    
    var body: some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                content()
            }
            .onAppear {
                viewModel.input.getQuestionSubject.send()
            }
            .onChange(of: viewModel.output.checkedAnswer) { oldValue, newValue in
                if let checkedAnswer = newValue {
                    router.pushView(MainNavigation.pushCheckedQuestion(checkedAnswer,
                                                                       viewModel.output.question,
                                                                       viewModel.output.answer))
                }
            }
    }
}

extension ExerciseQuestionView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            customToolBar()
            Spacer()
            switch viewModel.output.state {
            case .loader:
                loader()
            case .view:
                question()
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    func customToolBar() -> some View {
        HStack {
            Button {
                router.popView()
                viewModel.output.state = .loader
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
    
    @ViewBuilder
    func loader() -> some View {
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
    }
    
    @ViewBuilder
    func question() -> some View {
        VStack {
            Text(viewModel.output.question)
                .foregroundStyle(.mainPurple)
                .font(.custom("Montserrat-SemiBold", size: 20))
                .padding(.vertical, 20)
                .padding(.horizontal, 16)
            Spacer()
            TextField("Введи ответ на вопрос...", text: $viewModel.output.answer, axis: .vertical)
                .foregroundColor(.mainPurple)
                .font(.custom("Montserrat-Light", size: 16))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
            Spacer()
            buttonCheck()
                .padding(.bottom, 15)
        }
    }
    
    @ViewBuilder
    func buttonCheck() -> some View {
        Button {
            viewModel.output.state = .loader
            viewModel.input.sendAnswerSubject.send()
        } label: {
            VStack {
                Text("Проверить")
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
