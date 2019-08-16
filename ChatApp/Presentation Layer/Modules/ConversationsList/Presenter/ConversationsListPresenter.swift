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
  private let alertService: IAlertService
  
  // MARK: - Init
  
  init(output: IConversationsListPresenterOutput,
       fetchedResultsController: CAFetchedResultsController,
       communicationController: CACommunicationController,
       alertService: IAlertService) {
    
    self.output = output
    self.fetchedResultsController = fetchedResultsController
    self.alertService = alertService
    
    self.communicationController = communicationController
    self.communicationController.delegate = self
  }
  
}

// MARK: - IConversationsListPresenterInput

extension ConversationsListPresenter: IConversationsListPresenterInput {
  
  func performFetch() {
    fetchedResultsController.performFetch()
  }
  
  func selectedItem(at indexPath: IndexPath) {
    guard
      let conversation: Conversation = fetchedResultsController.item(at: indexPath),
      let user = conversation.user
      else {
        return
    }

    if user.isConfirmed {
      output?.converse(in: conversation, with: communicationController.session)
    } else if let peer = user.peer {
      communicationController.invite(peer: peer)
    }
  }
  
}

// MARK: -

extension ConversationsListPresenter: ICACommunicationControllerDelegate {
  
  func communicationController(_ communicationController: CACommunicationController,
                               peer: MCPeerID,
                               didReceiveInvitation invitationHandler: @escaping (Bool) -> ()) {
    
    let actions = { () -> [UIAlertAction] in
      let acceptAction = UIAlertAction(title: "ACCEPT_WORD".localized(), style: .default) { _ in
        invitationHandler(true)
      }
      
      let cancelAction = UIAlertAction(title: "CANCEL_WORD".localized(), style: .cancel) { _ in
        invitationHandler(false)
      }
      
      return [acceptAction, cancelAction]
    }
    
    let controller = alertService.controller(title: peer.displayName,
                                             message: "INVITE_WORD".localized(),
                                             actions: actions)
    
    output?.display(alert: controller)
  }
  
}
