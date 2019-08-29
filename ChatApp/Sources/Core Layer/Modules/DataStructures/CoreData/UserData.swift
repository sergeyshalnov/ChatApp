//
//  UserModel.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 15/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation
import MultipeerConnectivity.MCPeerID

struct UserModel {
  
  // MARK: - Variables
  
  let peer: MCPeerID
  let isOnline: Bool
  let isConfirmed: Bool
  
  // MARK: - Init
  
  init(peer: MCPeerID, isOnline: Bool, isConfirmed: Bool) {
    self.peer = peer
    self.isOnline = isOnline
    self.isConfirmed = isConfirmed
  }
  
}
