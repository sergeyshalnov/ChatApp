//
//  ConversationsListRouter.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 07/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import Foundation

final class ConversationsListRouter {
  
  weak var view: ConversationsListViewController?
  
  // MARK: - Init
  
  init(view: ConversationsListViewController) {
    self.view = view
  }
  
}

// MARK: - IConversationsListRouter

extension ConversationsListRouter: IConversationsListRouter {
  
  func navigate(to conversation: Conversation, animated: Bool) {
    fatalError()
  }
  
}
