//
//  DataStorageService.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 11/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation
import MultipeerConnectivity.MCPeerID

final class StorageService {
  
  // MARK: - Variables
  
  private var userStorage: IUserStorage
  private var conversationStorage: IConversationStorage
  private var messageStorage: IMessageStorage
  
  // MARK: - Init
  
  init(userStorage: IUserStorage,
       conversationStorage: IConversationStorage,
       messageStorage: IMessageStorage) {
    
    self.userStorage = userStorage
    self.conversationStorage = conversationStorage
    self.messageStorage = messageStorage
  }
  
}

// MARK: - IsStorageService

extension StorageService: IStorageService {
  
  func add(user peer: MCPeerID) {
    userStorage.add(user: peer)
  }
  
  func edit(user: UserModel) {
    userStorage.edit(user: user)
  }
  
  func delete(user peer: MCPeerID) {
    userStorage.delete(user: peer)
  }
  
  func edit(conversation: ConversationData) {
    conversationStorage.edit(conversation: conversation)
  }
  
  func delete(conversation: ConversationData) {
    conversationStorage.delete(conversation: conversation)
  }
  
  func add(message: MessageModel, from peer: MCPeerID) {
    messageStorage.add(message: message, from: peer)
  }
  
}
