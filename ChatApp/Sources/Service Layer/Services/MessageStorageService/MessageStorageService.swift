//
//  MessageStorageService.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 11/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation
import MultipeerConnectivity.MCPeerID

final class MessageStorageService {
  
  // MARK: - Variables
  
  private let messageStorage: IMessageStorage
  
  // MARK: - Init
  
  init(messageStorage: IMessageStorage) {
    self.messageStorage = messageStorage
  }
  
}

// MARK: - IMessageStorageService

extension MessageStorageService: IMessageStorageService {
  
  func add(message: MessageModel, from peer: MCPeerID) {
    messageStorage.add(message: message, from: peer)
  }
  
}


