//
//  CardView.swift
//  EnglishMessenger
//
//  Created by Данила on 23.04.2024.
//

import SwiftUI
import Combine

struct CardView: View {
    @EnvironmentObject var router: MainNavigationRouter
    @StateObject var viewModel: CardViewModel
    
    var body: some View {
        Color.profilePinky
            .ignoresSafeArea()
            .overlay {
                content()
            }
    }
}

extension CardView {
    @ViewBuilder
    func content() -> some View {
        VStack {
            customToolBar()
            Spacer()
            if viewModel.output.currentCount <= viewModel.output.cards.count {
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
            Text(viewModel.output.currentCount > viewModel.output.cards.count ? "\(viewModel.output.currentCount - 1)/\(viewModel.output.cards.count)"
                 : "\(viewModel.output.currentCount)/\(viewModel.output.cards.count)")
                .foregroundStyle(.mainPurple)
                .font(.custom("Montserrat-ExtraBold", size: 24))
            Spacer()
        }
        .padding([.horizontal, .vertical], 16)
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
