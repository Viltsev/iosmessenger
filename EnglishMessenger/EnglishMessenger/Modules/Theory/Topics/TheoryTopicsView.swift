//
//  TheoryTopicsView.swift
//  EnglishMessenger
//
//  Created by Данила on 28.04.2024.
//

import SwiftUI

struct TheoryTopicsView: View {
    @EnvironmentObject var router: MainNavigationRouter
    @StateObject var viewModel: TheoryTopicsViewModel
    
    var body: some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                content()
            }
    }
}

extension TheoryTopicsView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            customToolBar()
                .padding(.bottom, 30)
            topicsList()
                .padding(.bottom, 10)
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
            Text(viewModel.output.theory?.title ?? "")
                .foregroundStyle(.mainPurple)
                .font(.custom("Montserrat-ExtraBold", size: 20))
            Spacer()
        }
        .padding([.horizontal, .vertical], 16)
    }
    
    @ViewBuilder
    func topicsList() -> some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    if let theory = viewModel.output.theory {
                        ForEach(theory.topics, id: \.id) { topic in
                            topicView(topic: topic)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func topicView(topic: LocalTopic) -> some View {
        Button {
//            router.pushView(MainNavigation.pushTheoryTopicsView(category))
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(topic.title)
                        .foregroundColor(.mainPurple)
                        .multilineTextAlignment(.leading)
                        .font(.custom("Montserrat-Bold", size: 20))
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    
                    Text(topic.description)
                        .foregroundColor(.mainPurple)
                        .multilineTextAlignment(.leading)
                        .font(.custom("Montserrat-Light", size: 15))
                        .padding(.bottom, 20)
                }
                .padding(.horizontal, 16)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(.lightPinky)
            .cornerRadius(15)
            .padding(.horizontal, 16)
            .padding(.bottom, 15)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
