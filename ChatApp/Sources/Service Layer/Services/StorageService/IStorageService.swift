//
//  IDataStorageService.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 11/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation
import MultipeerConnectivity.MCPeerID

protocol IStorageService {
  
  func add(user peer: MCPeerID)
  func edit(user: UserModel)
  func delete(user peer: MCPeerID)
  
  func edit(conversation: ConversationData)
  func delete(conversation: ConversationData)
  
  func add(message: MessageModel, from peer: MCPeerID)
  
}
