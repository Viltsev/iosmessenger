//
//  CardsLearningView.swift
//  EnglishMessenger
//
//  Created by Данила on 22.04.2024.
//

import SwiftUI

struct CardsLearningView: View {
    @EnvironmentObject var router: MainNavigationRouter
    @StateObject private var viewModel: CardsLearningViewModel = CardsLearningViewModel()
    
    var body: some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                content()
            }
            .onAppear {
                viewModel.input.getToLearnCardsSubject.send()
            }
            .sheet(isPresented: $viewModel.output.isSheet) {
                sheetView()
                    .presentationDetents([.medium, .medium])
                    .presentationCornerRadius(15)
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
            switch viewModel.output.viewState {
            case .nothingWords:
                Spacer()
                nothingToLearn()
            case .hasWords:
                wordsToLearn()
                    .padding(.vertical, 30)
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    func sheetView() -> some View {
        VStack {
            TextField("Слово", text: $viewModel.output.word)
                .foregroundColor(.mainPurple)
                .font(.custom("Montserrat-Light", size: 24))
                .multilineTextAlignment(.center)
                .padding()
                .onChange(of: viewModel.output.word, setWord)
            
            TextField("Перевод", text: $viewModel.output.translation)
                .foregroundColor(.mainPurple)
                .font(.custom("Montserrat-Light", size: 24))
                .multilineTextAlignment(.center)
                .padding()
                .onChange(of: viewModel.output.translation, setTranslation)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.output.sets, id: \.id) { card in
                        setView(word: card.title, translation: card.description, isChosen: card.isChosen, id: card.id)
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.vertical, 25)
            
            Button {
                //viewModel.input.createSetSubject.send()
            } label: {
                Text("Создать")
                    .foregroundColor(.lightPurple)
                    .font(.custom("Montserrat-Bold", size: 24))
                    .padding()
            }
            .disabled(viewModel.output.createWordEnable)
        }
        .onAppear {
            viewModel.input.getCardSetSubject.send()
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
            viewModel.output.isSheet.toggle()
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
    
    @ViewBuilder
    func wordsToLearn() -> some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach(viewModel.output.toLearnCards, id: \.id) { card in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(card.text)
                                    .foregroundStyle(.mainPurple)
                                    .font(.custom("Montserrat-Bold", size: 20))
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                Text(card.explanation)
                                    .foregroundStyle(.mainPurple)
                                    .font(.custom("Montserrat-Light", size: 16))
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 10)
                            }
                            .padding(.vertical, 10)
                            Spacer()
                            Image("speaker")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .background(.lightPinky)
                        .cornerRadius(15)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 15)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func setView(word: String, translation: String, isChosen: Bool, id: Int) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.8)) {
                viewModel.input.chooseSetSubject.send(id)
            }
        } label: {
            HStack {
                Spacer()
                VStack(alignment: .center) {
                    Text(word)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .font(.custom("Montserrat-Bold", size: 20))
                        .padding(.top, 15)
                        .padding(.bottom, 15)
                    Text(translation)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .font(.custom("Montserrat-Regular", size: 10))
                        .padding(.bottom, 15)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(isChosen ? .mainPurple : .lightPurple)
            .cornerRadius(5)
            .padding(.bottom, 15)
        }
        .buttonStyle(.plain)
    }
}

extension CardsLearningView {
    func setWord() {
        viewModel.input.setWordSubject.send()
    }
    
    func setTranslation() {
        viewModel.input.setTranslationSubject.send()
    }
}
