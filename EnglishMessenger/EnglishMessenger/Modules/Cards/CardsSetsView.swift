//
//  CardsSetsView.swift
//  EnglishMessenger
//
//  Created by Данила on 22.04.2024.
//

import SwiftUI

struct CardsSetsView: View {
    @EnvironmentObject var router: MainNavigationRouter
    
    var body: some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                content()
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
            setCard(title: "Все слова", description: "Все твои сохранённые слова")
            Spacer()
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
    func setCard(title: String, description: String) -> some View {
        Button {
            
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .font(.custom("Montserrat-Bold", size: 20))
                        .padding(.top, 35)
                        .padding(.bottom, 15)
                    Text(description)
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
