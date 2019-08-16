//
//  MessageService.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 11/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation
import MultipeerConnectivity.MCSession

final class MessageService {
  
  // MARK: - Variables
  
  private let session: MCSession
  private let messageStorage: IMessageStorage
  
  // MARK: - Init
  
  init(session: MCSession, messageStorage: IMessageStorage) {
    self.session = session
    self.messageStorage = messageStorage
  }
  
}

// MARK: - IMessageService

extension MessageService: IMessageService {
  
  func send(_ message: String, to peer: MCPeerID) {
    do {
      let data = MessageModel(id: Generator.id(), text: message, isIncoming: false)
      let json = ["eventType": "TextMessage", "messageId": data.id, "text": message]
      let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
      
      try session.send(jsonData, toPeers: [peer], with: .reliable)
      
      messageStorage.add(message: data, from: peer)
      
    } catch {
      print("Error when send message to \(peer.description)")
      return
    }
  }
  
}
