//
//  SocketService.swift
//  EnglishMessenger
//
//  Created by Данила on 15.04.2024.
//

import Foundation
import StompClientLib
import SwiftUI
import Combine

class SocketService: ObservableObject, StompClientLibDelegate {
    @Published var username: String = ""
    @Published var senderId: String = ""
    @Published var recipientId: String = ""
    @Published var message: String = ""
    @Published var messages: [Message] = []
    
    private var socketClient: StompClientLib
    let apiService = GeneralApi()
    
    init() {
        self.socketClient = StompClientLib()
        let url = URL(string: "http://localhost:8080/ws")!
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url), delegate: self)
    }
        
    func connect() {
        let chatId = generateChatId(senderId: self.senderId, recipientId: self.recipientId)
        Task {
            do {
                let chatMessages = try await apiService.getAllMessages(chatId: chatId)
                await updataMessages(chatMessages)
            } catch {
                print("Network error!")
            }
        }
    }
    
    func sendMessage() {
        let userMessage = ServerMessage(type: "CHAT", content: self.message, sender: self.username, senderId: self.senderId, recipientId: self.recipientId)
        let chatId = generateChatId(senderId: self.senderId, recipientId: self.recipientId)
        do {
            let jsonData = try JSONEncoder().encode(userMessage)
            if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                socketClient.sendJSONForDict(dict: jsonDict as AnyObject, toDestination: "/app/chat.sendMessage/\(chatId)")
            }
        } catch {
            print("Error encoding chat message: \(error)")
        }
    }
    
    
}

extension SocketService {
    func stompClient(client: StompClientLib,
                     didReceiveMessageWithJSONBody jsonBody: AnyObject?,
                     akaStringBody stringBody: String?,
                     withHeader header: [String : String]?,
                     withDestination destination: String) {
        
        if let jsonBodyString = jsonString(from: jsonBody),
           let jsonData = jsonBodyString.data(using: .utf8),
           let message = try? JSONDecoder().decode(Message.self, from: jsonData) {
            withAnimation(.bouncy) {
                self.messages.append(message)
            }
        } else {
            print("Failed to parse JSON")
        }
        
        if let jsonBodyString = jsonString(from: jsonBody) {
            print("JSON Body as String: \(jsonBodyString)")
        } else {
            print("Failed to convert JSON Body to String")
        }
    }
    
    func stompClientDidDisconnect(client: StompClientLib) {
        print("socket is disconnected")
    }
    
    func stompClientDidConnect(client: StompClientLib) {
        print("socket is connected: \(client.description)")
        let chatId = generateChatId(senderId: self.senderId, recipientId: self.recipientId)
        socketClient.subscribe(destination: "/topic/public/\(chatId)")
        connect()
    }
    
    func serverDidSendReceipt(client: StompClientLib, withReceiptId receiptId: String) {
        print("to do")
    }
    
    func serverDidSendError(client: StompClientLib, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("to do")
    }
    
    func serverDidSendPing() {
        print("to do")
    }
}

extension SocketService {
    @MainActor
    private func updataMessages(_ chatMessages: [Message]) {
        self.messages.append(contentsOf: chatMessages)
    }
    
    func jsonString(from jsonBody: AnyObject?) -> String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody ?? [:], options: []),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return nil
        }
        return jsonString
    }
    
    func generateChatId(senderId: String, recipientId: String) -> String {
        let ids = [senderId, recipientId].sorted()
        return ids[0] + ids[1]
    }
}
