//
//  CardView.swift
//  EnglishMessenger
//
//  Created by Данила on 23.04.2024.
//

import SwiftUI
import ConfettiSwiftUI
import Combine

struct CardView: View {
    @EnvironmentObject var router: MainNavigationRouter
    @StateObject var viewModel: CardViewModel
    @State private var counter: Int = 0
    
    var body: some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                content()
            }
            .onChange(of: viewModel.output.currentCount) { oldValue, newValue in
                if (viewModel.output.currentCount - 1) == viewModel.output.cardsCount && !viewModel.output.cards.isEmpty {
                    viewModel.output.state = .notAllLearned
                } else if viewModel.output.cards.isEmpty {
                    viewModel.output.state = .allLearned
                }
            }
    }
}

extension CardView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            customToolBar()
            Spacer()
            switch viewModel.output.state {
            case .process:
                ZStack {
                    ForEach(viewModel.output.cards, id: \.id) { card in
                        CardDetailView(card: card, action: viewModel.input.saveToLearnedSubject, currentCount: $viewModel.output.currentCount)
                    }
                }
                Text("Нажми на карточку, чтобы перевернуть")
                    .foregroundStyle(.lightPurple)
                    .font(.custom("Montserrat-Regular", size: 13))
                    .padding()
                Spacer()
            case .allLearned:
                allWordsLearned()
                    .confettiCannon(counter: $counter, num: 100, colors: [.mainPurple, .lightPurple, .lightPinky])
                    .onAppear {
                        counter += 1
                    }
            case .notAllLearned:
                notAllWordsLearned()
            }
        }
    }
    
    @ViewBuilder
    func customToolBar() -> some View {
        HStack {
            Button {
                router.popView()
                viewModel.output.currentCount = 1
            } label: {
                Image(systemName: "multiply")
                    .font(.title3)
                    .bold()
            }
            Spacer()
            if viewModel.output.cards.isEmpty {
                Text("\(viewModel.output.cardsCount)/\(viewModel.output.cardsCount)")
                    .foregroundStyle(.mainPurple)
                    .font(.custom("Montserrat-ExtraBold", size: 24))
            } else {
                Text(viewModel.output.currentCount > viewModel.output.cardsCount
                     ? "\(viewModel.output.currentCount - 1)/\(viewModel.output.cardsCount)"
                     : "\(viewModel.output.currentCount)/\(viewModel.output.cardsCount)")
                    .foregroundStyle(.mainPurple)
                    .font(.custom("Montserrat-ExtraBold", size: 24))
            }
            Spacer()
        }
        .padding([.horizontal, .vertical], 16)
    }
    
    @ViewBuilder
    func allWordsLearned() -> some View {
        VStack {
            HStack {
                Text("Поздравляем!\nВсе слова изучены!")
                    .foregroundStyle(.mainPurple)
                    .font(.custom("Montserrat-ExtraBold", size: 24))
                Spacer()
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
            Image("congrat")
                .resizable()
                .scaledToFill()
                .frame(width: 250, height: 250)
                .padding(.vertical, 25)
            
            Spacer()
            
            buttonAgain()
        }
    }
    
    @ViewBuilder
    func notAllWordsLearned() -> some View {
        VStack {
            HStack {
                Text("Прекрасно!\nПродолжайте изучение!")
                    .foregroundStyle(.mainPurple)
                    .font(.custom("Montserrat-ExtraBold", size: 24))
                Spacer()
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
            Image("kittyCards")
                .resizable()
                .scaledToFill()
                .frame(width: 250, height: 250)
                .padding(.vertical, 25)
            
            Spacer()
            
            buttonContinue()
        }
    }
    
    @ViewBuilder
    func buttonContinue() -> some View {
        Button {
            viewModel.input.continueLearningSubject.send()
        } label: {
            VStack {
                Text("Продожить\nизучение")
                    .foregroundColor(.mainPurple)
                    .font(.custom("Montserrat-Bold", size: 20))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 20)
            }
            .frame(maxWidth: .infinity)
            .background (
                roundedRectangle()
            )
            .padding()
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    @ViewBuilder
    func buttonAgain() -> some View {
        Button {
            viewModel.input.learnAgainSubject.send()
        } label: {
            VStack {
                Text("Начать заново")
                    .foregroundColor(.mainPurple)
                    .font(.custom("Montserrat-Bold", size: 20))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 20)
            }
            .frame(maxWidth: .infinity)
            .background (
                roundedRectangle()
            )
            .padding()
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    @ViewBuilder
    func roundedRectangle() -> some View {
        RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
            .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
            .foregroundColor(.mainPurple)
    }
}

struct CardDetailView: View {
    var card: LocalCard
    var action: PassthroughSubject<LocalCard, Never>

    @Binding var currentCount: Int
    @State private var isFlipped: Bool = false
    @State private var offset = CGSize.zero
    @State private var color: Color = .mainPurple
    
    var body: some View {
    
        ZStack {
            cardView(text: card.text)
                .rotation3DEffect(
                    .degrees(isFlipped ? 0 : -90),
                                          axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .animation(isFlipped ? .linear.delay(0.35) : .linear, value: isFlipped)
            cardView(text: card.explanation)
                .rotation3DEffect(
                    .degrees(isFlipped ? 90 : 0),
                                          axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .animation(isFlipped ? .linear : .linear.delay(0.35), value:
                            isFlipped)
        }
        .onTapGesture {
            withAnimation(.easeIn) {
                isFlipped.toggle()
            }
        }
    }
    
    @ViewBuilder
    func cardView(text: String) -> some View {
        ZStack {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .cornerRadius(15)
                .padding(.horizontal, 25)
                .foregroundStyle(color)

            HStack {
                Text(text)
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .bold()
                    .padding(.horizontal, 16)
            }
        }
        .offset(x: offset.width, y: offset.height * 0.4)
        .rotationEffect(.degrees(Double(offset.width / 40)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    withAnimation {
                        changeColor(width: offset.width)
                    }
                }
                .onEnded { _ in
                    withAnimation {
                        swipeCard(width: offset.width)
                        changeColor(width: offset.width)
                        isFlipped.toggle()
                    }
                }
        )
    }
    
    func swipeCard(width: CGFloat) {
        switch width {
        case -500...(-150):
            currentCount += 1
            offset = CGSize(width: -100000, height: 0)
        case 150...500:
            action.send(card)
            currentCount += 1
            offset = CGSize(width: 100000, height: 0)
        default:
            offset = .zero
            
        }
    }
    
    func changeColor(width: CGFloat) {
        switch width {
        case -500...(-130):
            color = .red
        case 130...500:
            color = .green
        default:
            color = .mainPurple
        }
    }
}
