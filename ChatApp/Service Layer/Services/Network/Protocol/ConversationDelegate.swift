//
//  ConversationDelegate.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 02/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation

protocol ConversationDelegate {
  
  // For init conversation with specific peer
  func conversation(didSelectPeer peer: Peer)
  // Change button status for lost peer
  func conversation(didLostPeer peer: Peer)
  
}

protocol ConversationListDelegate {
  
  // Add sent message to sender
  func conversationList(sentMessage message: MessageData, toPeer peer: Peer)
  
}

