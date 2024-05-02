//
//  GTExercisesView.swift
//  EnglishMessenger
//
//  Created by Данила on 02.05.2024.
//

import SwiftUI

struct GTExercisesView: View {
    @EnvironmentObject var router: MainNavigationRouter
    @State private var text: String = ""
    @StateObject var viewModel: GTExercisesViewModel
    
    var body: some View {
        Color.mainPurple
            .ignoresSafeArea()
            .overlay {
                content()
            }
    }
}

extension GTExercisesView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(viewModel.output.exercises, id: \.id) { exercise in
                        ExerciseCardView(exercise: exercise, viewModel: viewModel)
                    }
                }
            }
            if viewModel.output.state == .answers {
                Spacer()
                checkAnswers()
                    .padding()
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    router.popView()
                    viewModel.output.state = .answers
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
    func checkAnswers() -> some View {
        Button {
            viewModel.input.checkAnswersSubject.send()
        } label: {
            Text("Проверить")
                .foregroundStyle(.white)
                .font(.custom("Montserrat-Bold", size: 20))
        }
    }
}

struct ExerciseCardView: View {
    @State private var answer: String = ""
    var exercise: LocalTraining
    @StateObject var viewModel: GTExercisesViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(exercise.exercise)
                        .foregroundStyle(.black)
                        .font(.custom("Montserrat-Bold", size: 14))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                    Spacer()
                }
                
                switch viewModel.output.state {
                case .answers:
                    HStack {
                        Spacer()
                        TextField("Твой ответ...", text: $answer)
                            .foregroundColor(.lightPurple)
                            .font(.custom("Montserrat-Light", size: 14))
                            .multilineTextAlignment(.center)
                            .onChange(of: answer) {
                                viewModel.input.writeAnswerSubject.send((answer, exercise.id))
                            }
                        Spacer()
                    }
                case .showCorrect:
                    HStack {
                        Spacer()
                        Text(exercise.currentAnswer)
                            .foregroundColor(exercise.isCorrect ? .green : .red)
                            .font(.custom("Montserrat-Light", size: 14))
                        Spacer()
                    }
                    if !exercise.isCorrect {
                        HStack {
                            Spacer()
                            Text(exercise.rightAnswer)
                                .foregroundColor(.lightPurple)
                                .font(.custom("Montserrat-Light", size: 14))
                            Spacer()
                        }
                        .padding(.vertical, 5)
                    }
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
}
