//
//  IConversationsListRouter.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 07/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import Foundation

protocol IConversationsListRouter {
  
  func navigate(to conversation: Conversation, animated: Bool)
  
}
