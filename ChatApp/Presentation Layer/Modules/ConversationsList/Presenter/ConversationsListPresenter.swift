//
//  ConversationsListPresenter.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 07/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import Foundation
import MultipeerConnectivity.MCPeerID

final class ConversationsListPresenter {
  
  private weak var output: IConversationsListPresenterOutput?
  private let fetchedResultsController: CAFetchedResultsController
  private let communicationController: CACommunicationController
  
  // MARK: - Init
  
  init(output: IConversationsListPresenterOutput,
       fetchedResultsController: CAFetchedResultsController,
       communicationController: CACommunicationController) {
    
    self.output = output
    self.fetchedResultsController = fetchedResultsController
    self.communicationController = communicationController
  }
  
}

// MARK: - IConversationsListPresenterInput

extension ConversationsListPresenter: IConversationsListPresenterInput {
  
  func performFetch() {
    fetchedResultsController.performFetch()
  }
  
  func selectedItem(at indexPath: IndexPath) {
    guard let conversation: Conversation = fetchedResultsController.item(at: indexPath) else {
      return
    }
    
    output?.converse(in: conversation)
  }
  
}
