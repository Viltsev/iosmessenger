//
//  TheoryMainView.swift
//  EnglishMessenger
//
//  Created by Данила on 28.04.2024.
//

import SwiftUI

struct TheoryMainView: View {
    @EnvironmentObject var router: MainNavigationRouter
    @StateObject var viewModel: TheoryMainViewModel
    
    var body: some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                content()
            }
    }
}

extension TheoryMainView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            HStack {
                Image("darkPurpleBlob")
                    .imageScale(.small)
                    .overlay {
                        Text("Теория")
                            .foregroundStyle(.white)
                            .font(.custom("Montserrat-Regular", size: 35))
                    }
                Spacer()
            }
            .padding(.bottom, 20)
            categoryList()
                .padding(.bottom, 10)
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    router.popView()
                } label: {
                    Image(systemName: "multiply")
                        .font(.title3)
                        .bold()
                }
            }
        })
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func categoryList() -> some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach(viewModel.output.theory, id: \.id) { category in
                        categoryView(title: category.title, description: category.description)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func categoryView(title: String, description: String) -> some View {
        Button {
//            action()
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .font(.custom("Montserrat-Regular", size: 24))
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    Text(description)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .font(.custom("Montserrat-Light", size: 16))
                        .padding(.bottom, 20)
                }
                .padding(.horizontal, 16)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(.white)
            .cornerRadius(15)
            .padding(.horizontal, 16)
            .padding(.bottom, 15)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
