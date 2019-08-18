//
//  ConversationsListRouter.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 07/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import Foundation
import MultipeerConnectivity.MCSession

final class ConversationsListRouter {
  
  // MARK: - Variables
  
  private var presentationAssembly: IPresentationAssembly
  weak var view: ConversationsListViewController?
  
  // MARK: - Init
  
  init(view: ConversationsListViewController, presentationAssembly: IPresentationAssembly) {
    self.view = view
    self.presentationAssembly = presentationAssembly
  }
  
}

// MARK: - IConversationsListRouter

extension ConversationsListRouter: IConversationsListRouter {
  
  func navigate(to conversation: Conversation, with session: MCSession, animated: Bool) {
    let controller = presentationAssembly.conversation(conversation, with: session)
    view?.navigationController?.pushViewController(controller, animated: animated)
  }
  
  func profile(animated: Bool) {
    let controller = presentationAssembly.profile()
    view?.present(controller, animated: animated)
//    view?.navigationController?.pushViewController(controller, animated: animated)
  }
  
}
