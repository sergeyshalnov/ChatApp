//
//  IConversationsListPresenterOutput.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 07/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol IConversationsListPresenterOutput: class {
  
  func invite(from peer: MCPeerID, with actions: [UIAlertAction])
  func display(conversation: Conversation, with session: MCSession)
  
  func noProfile()
  
}
