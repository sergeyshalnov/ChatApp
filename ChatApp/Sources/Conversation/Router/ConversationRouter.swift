//
//  ConversationRouter.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 11/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import Foundation

final class ConversationRouter {
  
  // MARK: - Variables
  
  weak var view: ConversationViewController?
  
  // MARK: - Init
  
  init(view: ConversationViewController) {
    self.view = view
  }
  
}

// MARK: - IConversationRouter

extension ConversationRouter: IConversationRouter {
  
  func close(animated: Bool) {
    view?.navigationController?.popViewController(animated: animated)
  }
  
}
