//
//  TestingView.swift
//  EnglishMessenger
//
//  Created by Данила on 02.03.2024.
//

import SwiftUI

struct TestingView: View {
    @EnvironmentObject var viewModel: TestingViewModel
    @EnvironmentObject var router: StartNavigationRouter
    
    var body: some View {
        Color.lightPinky
            .ignoresSafeArea()
            .overlay {
                content()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // backButtonAction()
                    } label: {
                        Image("backButton")
                            .imageScale(.large)
                    }
                }
            }
    }
}

extension TestingView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            TabView(selection: $viewModel.output.pageNumber) {
                ForEach(viewModel.output.testData, id: \.id) { data in
                    let answersArray = [(1, data.answerOne), (2, data.answerTwo), (3, data.answerThree), (4, data.answerFour ?? "")]
                    questionView(question: data.question, answers: answersArray, questionId: data.id, currentAnswerId: data.currentAnswerId)
                        .tag(data.id)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            Spacer()
            TestProgressView(progress: CGFloat(Double(viewModel.output.pageNumber) * 0.04))
                .frame(height: 10)
                .padding(.horizontal, 50)
                .padding(.bottom, 16)
        }
    }
    
    @ViewBuilder
    func questionView(question: String, answers: [(Int, String)], questionId: Int, currentAnswerId: Int) -> some View {
        VStack {
            TitleTextView(text: question, size: 30)
                .padding(.top, 50)
            Spacer()
            VStack(spacing: 20) {
                ForEach(answers, id: \.0) { (id, answer) in
                    if !answer.isEmpty {
                        TestButtonView(id: questionId, actionPublisher: viewModel.input.setAnswersSubject, text: answer, currentAnswerId: currentAnswerId, buttonId: id)
                    }
                }
            }
            Spacer()
            if questionId == 25 {
                PurpleButtonView(text: "Check results", actionPublisher: viewModel.input.checkResultsSubject, action: checkResultsAction)
                    .padding(.bottom, 20)
            }
        }
    }
}

extension TestingView {
    func checkResultsAction() {
        router.pushView(StartNavigation.pushTestResultsView)
    }
}



#Preview {
    TestingView()
}
