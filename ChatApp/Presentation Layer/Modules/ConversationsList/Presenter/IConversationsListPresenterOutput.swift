//
//  IConversationsListPresenterOutput.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 07/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import Foundation
import MultipeerConnectivity.MCPeerID

protocol IConversationsListPresenterOutput: class {
  
  func converse(in conversation: Conversation)
  
}
