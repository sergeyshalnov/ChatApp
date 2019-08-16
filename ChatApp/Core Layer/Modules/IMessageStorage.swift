//
//  IMessageStorage.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 11/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation
import MultipeerConnectivity.MCPeerID

protocol IMessageStorage {
  
  func add(message: MessageModel, from peer: MCPeerID)
  
}
