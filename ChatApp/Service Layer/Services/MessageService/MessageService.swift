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
      let model = MessageModel(id: Generator.id(), text: message, isIncoming: true)
      let data = try JSONEncoder().encode(model)
      
      try session.send(data, toPeers: [peer], with: .reliable)
      
      model.isIncoming = false
      
      messageStorage.add(message: model, from: peer)
    } catch {
      print("Error when send message to \(peer.description)")
      return
    }
  }
  
}
