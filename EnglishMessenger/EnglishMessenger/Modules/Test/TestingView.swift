//
//  TestingView.swift
//  EnglishMessenger
//
//  Created by Данила on 02.03.2024.
//

import SwiftUI

struct TestingView: View {
    @State private var pageNumber = 0
    @State var progress: CGFloat = 0.0
    
    private let mockTestData: [MockTestData] = [
        MockTestData(questionNumber: 1, question: "Question 1",
                     answer1: "answer 1",
                     answer2: "answer 2",
                     answer3: "answer 3",
                     answer4: "answer 4"),
        MockTestData(questionNumber: 2, question: "Question 2",
                     answer1: "answer 1",
                     answer2: "answer 2",
                     answer3: "answer 3",
                     answer4: "answer 4"),
        MockTestData(questionNumber: 3, question: "Question 3",
                     answer1: "answer 1",
                     answer2: "answer 2",
                     answer3: "answer 3",
                     answer4: "answer 4"),
        MockTestData(questionNumber: 4, question: "Question 4",
                     answer1: "answer 1",
                     answer2: "answer 2",
                     answer3: "answer 3",
                     answer4: "answer 4"),
        MockTestData(questionNumber: 5, question: "Question 5",
                     answer1: "answer 1",
                     answer2: "answer 2",
                     answer3: "answer 3",
                     answer4: "answer 4")
    ]
    
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
            TabView(selection: $pageNumber) {
                ForEach(mockTestData, id: \.id) { data in
                    let answersArray = [data.answer1, data.answer2, data.answer3, data.answer4]
                    questionView(question: data.question, answers: answersArray, number: data.questionNumber)
                        .tag(data.questionNumber)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            Spacer()
            TestProgressView(progress: CGFloat(Double(pageNumber) * 0.2))
                .frame(height: 10)
                .padding(.horizontal, 50)
                .padding(.bottom, 16)
        }
    }
    
    @ViewBuilder
    func questionView(question: String, answers: [String], number: Int) -> some View {
        VStack {
            TitleTextView(text: question, size: 30)
                .padding(.top, 50)
            Spacer()
            VStack(spacing: 20) {
                ForEach(answers, id: \.self) { answer in
                    TestButtonView(text: answer)
                }
            }
            Spacer()
            if number == 5 {
                PurpleButtonView(text: "Check results")
                    .padding(.bottom, 20)
            }
        }
    }
}

struct MockTestData {
    let id: UUID = UUID()
    let questionNumber: Int
    let question: String
    let answer1: String
    let answer2: String
    let answer3: String
    let answer4: String
}

#Preview {
    TestingView()
}
