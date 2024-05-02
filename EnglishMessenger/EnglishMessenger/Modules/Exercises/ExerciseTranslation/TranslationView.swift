//
//  TranslationView.swift
//  EnglishMessenger
//
//  Created by Данила on 02.05.2024.
//

import SwiftUI

struct TranslationView: View {
    @EnvironmentObject var router: MainNavigationRouter
    @StateObject var viewModel: TranslationViewModel
    
    var body: some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                content()
            }
            .onChange(of: viewModel.output.checkedTranslation) { oldValue, newValue in
                if let checkedTranslation = newValue {
                    router.pushView(MainNavigation.pushTranslationCheckView(checkedTranslation,
                                                                            viewModel.output.text,
                                                                            viewModel.output.translation
                                                                           )
                    )
                }
            }
    }
}

extension TranslationView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            customToolBar()
                .padding(.bottom, 30)
            info()
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
            Text("Перевод текста")
                .foregroundStyle(.mainPurple)
                .font(.custom("Montserrat-ExtraBold", size: 18))
            Spacer()
        }
        .padding([.horizontal, .vertical], 16)
    }
    
    @ViewBuilder
    func info() -> some View {
        VStack {
            switch viewModel.output.state {
            case .loader:
                loader()
            case .view:
                exercise()
            }
        }
    }
    
    @ViewBuilder
    func exercise() -> some View {
        Text(viewModel.output.text)
            .foregroundStyle(.mainPurple)
            .font(.custom("Montserrat-SemiBold", size: 13))
            .padding(.horizontal, 16)
        Spacer()
        TextField("Переведи текст здесь...", text: $viewModel.output.translation, axis: .vertical)
            .foregroundColor(.mainPurple)
            .font(.custom("Montserrat-Light", size: 16))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16)
        Spacer()
        checkButton()
            .padding(.bottom, 15)
    }
    
    @ViewBuilder
    func loader() -> some View {
        Spacer()
        GifImage(name: "pedro")
            .frame(width: 250, height: 250)
            .cornerRadius(125)
            .background(
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 2))
                    .foregroundColor(.mainPurple)
            )
        Spacer()
    }
    
    @ViewBuilder
    func checkButton() -> some View {
        Button {
            viewModel.output.state = .loader
            viewModel.input.checkTranslation.send()
        } label: {
            VStack {
                Text("Проверить")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-Bold", size: 16))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 20)
            }
            .frame(maxWidth: .infinity)
            .background (
                RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                    .foregroundColor(.mainPurple)
            )
        }
        .buttonStyle(ScaleButtonStyle())
        .padding(.horizontal, 16)
    }
}
