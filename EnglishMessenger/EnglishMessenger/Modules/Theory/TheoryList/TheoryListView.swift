//
//  TheoryListViewModel.swift
//  EnglishMessenger
//
//  Created by Данила on 28.04.2024.
//

import SwiftUI

struct TheoryListView: View {
    @EnvironmentObject var router: MainNavigationRouter
    @StateObject var viewModel: TheoryListViewModel
    
    var body: some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                content()
            }
    }
}

extension TheoryListView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            customToolBar()
                .padding(.bottom, 30)
            theoryList()
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
            if let title = viewModel.output.theory?.title {
                Text(title)
                    .foregroundStyle(.mainPurple)
                    .font(.custom("Montserrat-ExtraBold", size: 20))
            } else if let subTitle = viewModel.output.theorySubtopic?.title {
                Text(subTitle)
                    .foregroundStyle(.mainPurple)
                    .font(.custom("Montserrat-ExtraBold", size: 20))
            }
            
            Spacer()
        }
        .padding([.horizontal, .vertical], 16)
    }
    
    @ViewBuilder
    func theoryList() -> some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    if let theory = viewModel.output.theory {
                        if !theory.theoryList.isEmpty {
                            ForEach(theory.theoryList, id: \.id) { theory in
                                theoryView(theory: theory)
                            }
                        } else {
                            ForEach(theory.subtopicList, id: \.id) { subtopic in
                                subtopicView(subtopic: subtopic)
                            }
                        }
                    } else if let theorySub = viewModel.output.theorySubtopic {
                        ForEach(theorySub.theoryList, id: \.id) { theory in
                            theoryView(theory: theory)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func theoryView(theory: LocalTheoryList) -> some View {
        Button {
            router.pushView(MainNavigation.pushTheoryCardView(theory))
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(theory.title)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .font(.custom("Montserrat-Bold", size: 20))
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    
                    Text(theory.level)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .font(.custom("Montserrat-Light", size: 15))
                        .padding(.bottom, 20)
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
    
    @ViewBuilder
    func subtopicView(subtopic: LocalSubtopicList) -> some View {
        Button {
            router.pushView(MainNavigation.pushTheoryListViewSub(subtopic))
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(subtopic.title)
                        .foregroundColor(.mainPurple)
                        .multilineTextAlignment(.leading)
                        .font(.custom("Montserrat-Bold", size: 20))
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    
                    Text(subtopic.description)
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
