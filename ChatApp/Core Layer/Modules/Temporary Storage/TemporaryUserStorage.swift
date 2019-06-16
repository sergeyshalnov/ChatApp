//
//  TemporaryUserStorage.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 17/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation
import MultipeerConnectivity


protocol ITemporaryUserStorage {
  
  func add(user: TemporaryUser)
  func delete(conversationId: String)
  
  func change(confirmed: Bool, peer: MCPeerID)
  
  func find(peer: MCPeerID) -> TemporaryUser?
  func find(conversationId: String) -> TemporaryUser?
}

class TemporaryUserStorage: ITemporaryUserStorage {
  
  var users: [TemporaryUser] = []
  
  func add(user: TemporaryUser) {
    users += [user]
  }
  
  func find(peer: MCPeerID) -> TemporaryUser? {
    if let result = users.filter({ $0.peer == peer }).first {
      return result
    } else {
      return nil
    }
  }
  
  func find(conversationId: String) -> TemporaryUser? {
    if let result = users.filter({ $0.conversationId == conversationId }).first {
      return result
    } else {
      return nil
    }
  }
  
  func delete(conversationId: String) {
    users = users.filter({ $0.conversationId != conversationId })
  }
  
  func change(confirmed: Bool, peer: MCPeerID) {
    users = users.map { (user) -> TemporaryUser in
      if user.peer == peer {
        let newUser = TemporaryUser(conversationId: user.conversationId, peer: user.peer, isConfirmed: confirmed)
        return newUser
      } else {
        return user
      }
    }
  }
  
}

struct TemporaryUser {
  
  let conversationId: String
  let peer: MCPeerID
  var isConfirmed: Bool
  
  init(conversationId id: String, peer: MCPeerID, isConfirmed: Bool = false) {
    self.conversationId = id
    self.peer = peer
    self.isConfirmed = isConfirmed
  }
}
