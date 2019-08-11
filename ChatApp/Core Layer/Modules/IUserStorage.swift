//
//  IUserStorage.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 11/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation
import MultipeerConnectivity.MCPeerID

protocol IUserStorage {
  
  func users() -> [User]
  func user(by peer: MCPeerID) -> User?
  
  func add(user peer: MCPeerID)
  func edit(user: UserData)
  func delete(user peer: MCPeerID)
  
}
