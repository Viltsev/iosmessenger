//
//  CardsSetsView.swift
//  EnglishMessenger
//
//  Created by Данила on 22.04.2024.
//

import SwiftUI

struct CardsSetsView: View {
    @EnvironmentObject var router: MainNavigationRouter
    @StateObject private var viewModel: CardsSetsViewModel = CardsSetsViewModel()
    
    var body: some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                content()
            }
            .onChange(of: viewModel.output.isSheet, { oldValue, newValue in
                if oldValue == true {
                    viewModel.input.getCardSetSubject.send()
                }
            })
            .onAppear {
                viewModel.input.getCardSetSubject.send()
            }
            .sheet(isPresented: $viewModel.output.isSheet) {
                sheetView()
                    .presentationDetents([.medium, .medium])
                    .presentationCornerRadius(15)
            }
    }
}

extension CardsSetsView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            customToolBar()
                .padding(.bottom, 30)
            createSet()
                .padding(.bottom, 50)
            scrollSets()
            Spacer()
        }
    }
    
    @ViewBuilder
    func sheetView() -> some View {
        VStack {
            TextField("Название сета", text: $viewModel.output.setTitle)
                .foregroundColor(.mainPurple)
                .font(.custom("Montserrat-Light", size: 24))
                .multilineTextAlignment(.center)
                .padding()
                .onChange(of: viewModel.output.setTitle,  setTitleAction)
            
            TextField("Описание сета", text: $viewModel.output.setDescription)
                .foregroundColor(.mainPurple)
                .font(.custom("Montserrat-Light", size: 24))
                .multilineTextAlignment(.center)
                .padding()
                .onChange(of: viewModel.output.setDescription,  setDescriptionAction)
            
            Button {
                viewModel.input.createSetSubject.send()
            } label: {
                Text("Создать")
                    .foregroundColor(.lightPurple)
                    .font(.custom("Montserrat-Bold", size: 24))
                    .padding()
            }
            .disabled(viewModel.output.createSetEnabled)
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
            Text("Сеты слов")
                .foregroundStyle(.mainPurple)
                .font(.custom("Montserrat-ExtraBold", size: 24))
            Spacer()
        }
        .padding([.horizontal, .vertical], 16)
    }
    
    @ViewBuilder
    func createSet() -> some View {
        Button {
            viewModel.output.isSheet.toggle()
        } label: {
            HStack {
                Image("add")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding()
                Spacer()
                Text("Создать сет")
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
    func scrollSets() -> some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(viewModel.output.sets, id: \.id) { set in
                    setCard(set: set)
                }
            }
        }
    }
    
    @ViewBuilder
    func setCard(set: LocalCardSet) -> some View {
        Button {
            router.pushView(MainNavigation.pushCardsSet(set))
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(set.title)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .font(.custom("Montserrat-Bold", size: 20))
                        .padding(.top, 35)
                        .padding(.bottom, 15)
                    Text(set.description)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .font(.custom("Montserrat-Regular", size: 16))
                        .padding(.bottom, 35)
                }
                .padding(.horizontal, 16)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(.lightPurple)
            .cornerRadius(15)
            .padding(.horizontal, 16)
            .padding(.bottom, 15)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

extension CardsSetsView {
    func setTitleAction() {
        viewModel.input.setTitleSubject.send()
    }
    
    func setDescriptionAction() {
        viewModel.input.setDescriptionSubject.send()
    }
}
