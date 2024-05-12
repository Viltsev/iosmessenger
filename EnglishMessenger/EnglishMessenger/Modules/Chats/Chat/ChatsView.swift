//
//  ChatsView.swift
//  EnglishMessenger
//
//  Created by Данила on 03.04.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatsView: View {
    @State var user: User
    @EnvironmentObject var router: MainNavigationRouter
    @StateObject private var socketService: SocketService = SocketService()
    @StateObject private var viewModel: ChatsViewModel = ChatsViewModel()
    @GestureState private var isLongPress = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    backButtonAction()
                } label: {
                    Image("backButton")
                        .imageScale(.large)
                }
                Spacer()
                Text(user.username)
                    .font(.title3)
                Spacer()
                    WebImage(url: URL(string: user.photo))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .cornerRadius(20)
                        .background(
                            Circle()
                                .stroke(style: StrokeStyle(lineWidth: 2))
                                .foregroundColor(.white)
                        )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            Spacer()
            ScrollView(showsIndicators: false) {
                ForEach(socketService.messages, id: \.idChat) { message in
                   if message.type == "CHAT" {
                       messageView(message: message)
                    }
                }.rotationEffect(.degrees(180))
            }.rotationEffect(.degrees(180))
            .background(Color.gray.opacity(0.1))
            Spacer()
            HStack {
                TextField("Сообщение...", text: $socketService.message, axis: .vertical)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .onSubmit {
                        sendMessage()
                    }
                switch viewModel.output.chatMode {
                case .sendMessage:
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 18))
                        .padding(.horizontal, 10)
                        .onTapGesture {
                            sendMessage()
                        }
                        .onLongPressGesture {
                            withAnimation(.bouncy) {
                                viewModel.input.changeChatModeSubject.send(.checkGrammar)
                            }
                        }
                case .checkGrammar:
                    Image(systemName: "textformat")
                        .font(.system(size: 18))
                        .padding(.horizontal, 10)
                        .onTapGesture {
                            if !socketService.message.isEmpty {
                                viewModel.input.checkGrammarSubject.send(socketService.message)
                            }
                        }
                        .onChange(of: viewModel.output.correctedMessage,  { oldValue, newValue in
                            socketService.message = newValue
                        })
                        .onLongPressGesture(minimumDuration: 0.5) {
                            withAnimation(.bouncy) {
                                viewModel.input.changeChatModeSubject.send(.sendMessage)
                            }
                        }
                    
                }
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 15)
        }
        .onAppear {
            let email = UserDefaults.standard.string(forKey: "email") ?? "email"
            let firstName = UserDefaults.standard.string(forKey: "firstName") ?? "firstName"
            let lastName = UserDefaults.standard.string(forKey: "lastName") ?? "lastName"
            let username = "\(firstName) \(lastName)"
            socketService.username = username
            socketService.senderId = email
            socketService.recipientId = user.email
        }
    }
    
    @ViewBuilder
    func messageView(message: Message) -> some View {
        if message.sender == socketService.username {
            myMessage(text: message.content ?? "")
        } else {
            otherMessage(text: message.content ?? "")
        }
    }
    
    @ViewBuilder
    func myMessage(text: String) -> some View {
        HStack {
            Spacer()
            Text(text)
                .padding()
                .foregroundColor(.white)
                .background(.mainPurple.opacity(0.8))
                .cornerRadius(10)
                .contextMenu {
                    Button {
                        UIPasteboard.general.string = text
                    } label: {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                    
                    Button {
                        
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
        }
    }
    
    @ViewBuilder
    func otherMessage(text: String) -> some View {
        HStack {
            Text(text)
                .padding()
                .background(.lightPinky)
                .cornerRadius(10)
                .contextMenu {
                    Button {
                        UIPasteboard.general.string = text
                    } label: {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                    
                    Button {
                        
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
            Spacer()
        }
    }
}

extension ChatsView {
    func sendMessage() {
        if !socketService.message.isEmpty {
            withAnimation {
                socketService.sendMessage()
                socketService.message = ""
            }
        }
    }
    
    func backButtonAction() {
        router.popView()
    }
}
