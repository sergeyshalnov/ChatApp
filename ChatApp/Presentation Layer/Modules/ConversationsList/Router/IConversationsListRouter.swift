//
//  IConversationsListRouter.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 07/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import Foundation
import MultipeerConnectivity.MCSession

protocol IConversationsListRouter {
  
  func navigate(to conversation: Conversation, with session: MCSession, animated: Bool)
  func profile()
  
}
