//
//  DictionaryView.swift
//  EnglishMessenger
//
//  Created by Данила on 02.05.2024.
//

import SwiftUI

struct DictionaryView: View {
    @State var text: String = ""
    @StateObject private var viewModel: DictionaryViewModel = DictionaryViewModel()
    
    var body: some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                content()
            }
            .sheet(isPresented: $viewModel.output.isSheet) {
                sheetView()
                    .presentationDetents([.medium, .medium])
                    .presentationCornerRadius(15)
            }
    }
}

extension DictionaryView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            HStack {
                Image("darkPurpleBlob")
                    .imageScale(.small)
                    .overlay {
                        Text("Словарь")
                            .foregroundStyle(.white)
                            .font(.custom("Montserrat-Regular", size: 35))
                    }
                Spacer()
            }
            .padding(.bottom, 20)
            HStack {
                TextField("Поиск", text: $text)
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-Light", size: 20))
                    .multilineTextAlignment(.leading)
                    .padding([.vertical, .horizontal], 10)
                Spacer()
                Button {
                    
                } label: {
                    Image("search")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .padding([.vertical, .horizontal], 10)
                }
                .buttonStyle(.plain)
            }
            .frame(maxWidth: .infinity)
            .background(.lightPurple)
            .cornerRadius(15)
            .padding(.horizontal, 16)
            .padding(.bottom, 30)
            words()
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func words() -> some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach(viewModel.output.dictionary, id: \.id) { card in
                        SearchedWords(viewModel: viewModel, text: card.word, translation: card.translation)
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
    
    @ViewBuilder
    func sheetView() -> some View {
        VStack {
            Text(viewModel.output.word)
                .foregroundColor(.mainPurple)
                .font(.custom("Montserrat-Light", size: 24))
                .multilineTextAlignment(.center)
                .padding()
//                .onChange(of: viewModel.output.word, setWord)
            
            Text(viewModel.output.translation)
                .foregroundColor(.mainPurple)
                .font(.custom("Montserrat-Light", size: 24))
                .multilineTextAlignment(.center)
                .padding()
//                .onChange(of: viewModel.output.translation, setTranslation)
            
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
                viewModel.input.createCardSubject.send()
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
}

struct SearchedWords: View {
    @StateObject var viewModel: DictionaryViewModel
    @State private var isAdded: Bool = false
    var text: String
    var translation: String
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(text)
                    .foregroundStyle(.mainPurple)
                    .font(.custom("Montserrat-Bold", size: 20))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                Text(translation)
                    .foregroundStyle(.mainPurple)
                    .font(.custom("Montserrat-Light", size: 16))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
            }
            .padding(.vertical, 10)
            Spacer()
            if isAdded {
                Image("checkmark")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding()
            } else {
                Button {
                    viewModel.output.word = text
                    viewModel.output.translation = translation
                    viewModel.output.isSheet = true
                } label: {
                    Image("add")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(.lightPinky)
        .cornerRadius(15)
        .padding(.horizontal, 16)
        .padding(.bottom, 15)
    }
}
