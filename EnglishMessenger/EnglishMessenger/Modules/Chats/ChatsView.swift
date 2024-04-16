//
//  ChatsView.swift
//  EnglishMessenger
//
//  Created by Данила on 03.04.2024.
//

import SwiftUI

struct ChatsView: View {
    @State var user: User
    @EnvironmentObject var router: MainNavigationRouter
    @StateObject private var socketService: SocketService = SocketService()
    
    @State private var messageText = ""
    @State var messages: [String] = ["\(UserDefaults.standard.string(forKey: "email") ?? "email")"]
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(socketService.messages, id: \.idChat) { message in
                   if message.type == "CHAT" {
                       withAnimation(.spring.delay(0.8)) {
                           messageView(message: message)
                       }
                    }
                }.rotationEffect(.degrees(180))
            }.rotationEffect(.degrees(180))
            .background(Color.gray.opacity(0.1))
            
            HStack {
                TextField("Type...", text: $socketService.message)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .onSubmit {
                        sendMessage()
                    }
                
                Button {
                    sendMessage()
                } label: {
                    Image(systemName: "paperlane.fill")
                }
                .font(.system(size: 26))
                .padding(.horizontal, 10)
            }
            .padding()
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
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Button {
                        backButtonAction()
                    } label: {
                        Image("backButton")
                            .imageScale(.large)
                    }
                    Spacer()
                    Text(user.email)
                        .font(.title3)
                    Spacer()
                }
                .padding(.vertical, 15)
            }
        }
    }
    
    func sendMessage() {
        withAnimation {
            socketService.sendMessage()
            socketService.message = ""
        }
    }
    
    func backButtonAction() {
        router.popView()
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
                .background(.blue.opacity(0.8))
                .cornerRadius(10)
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
        }
    }
    
    @ViewBuilder
    func otherMessage(text: String) -> some View {
        HStack {
            Text(text)
                .padding()
                .background(.gray.opacity(0.15))
                .cornerRadius(10)
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
            Spacer()
        }
    }
}
