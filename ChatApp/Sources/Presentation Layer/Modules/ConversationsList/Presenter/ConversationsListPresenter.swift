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
  
  // MARK: - Variables
  
  private weak var output: IConversationsListPresenterOutput?
  
  private let fetchedResultsController: CAFetchedResultsController
  private let communicationController: CACommunicationController
  
  // MARK: - Init
  
  init(output: IConversationsListPresenterOutput,
       fetchedResultsController: CAFetchedResultsController,
       communicationController: CACommunicationController) {
    
    self.output = output
    
    self.fetchedResultsController = fetchedResultsController
    self.fetchedResultsController.accessoryType = .disclosureIndicator
    
    self.communicationController = communicationController
    self.communicationController.delegate = self
  }
  
}

// MARK: - IConversationsListPresenterInput

extension ConversationsListPresenter: IConversationsListPresenterInput {
  
  func startCommunicationService() {
    guard !communicationController.isRunning else {
      return
    }
    
    communicationController.stop()
    communicationController.start { [weak self] (isRunning) -> () in
      if isRunning {
        #if DEBUG
        print("Communication service is running...")
        #endif
      } else {
        self?.output?.noProfile()
      }
    }
  }
  
  func performFetch() {
    CoreDataManager().terminate()
    fetchedResultsController.performFetch()
  }
  
  func selectedItem(at indexPath: IndexPath) {
    guard
      let conversation: Conversation = fetchedResultsController.item(at: indexPath),
      let user = conversation.user
      else {
        return
    }
    
    if user.isConfirmed, let session = communicationController.session {
      output?.display(conversation: conversation, with: session)
    } else if let peer = user.peer {
      communicationController.invite(peer: peer)
      output?.display(title: peer.displayName, message: String.inviteSentMessageWord)
    }
  }
  
}

// MARK: - ICACommunicationControllerDelegate

extension ConversationsListPresenter: ICACommunicationControllerDelegate {
  
  func communicationController(_ communicationController: CACommunicationController,
                               peer: MCPeerID,
                               didReceiveInvitation invitationHandler: @escaping (Bool) -> ()) {
    
    
    let acceptAction = UIAlertAction(title: String.acceptInviteWord, style: .default) { _ in
      invitationHandler(true)
    }
    
    let cancelAction = UIAlertAction(title: String.cancelInviteWord, style: .cancel) { _ in
      invitationHandler(false)
    }
    
    output?.invite(from: peer, with: [acceptAction, cancelAction])
  }
  
}

// MARK: - Private String

private extension String {
  
  static let inviteSentMessageWord = "INVITE_SENT_MESSAGE_WORD".localized()
  static let acceptInviteWord = "ACCEPT_INVITE_WORD".localized()
  static let cancelInviteWord = "CANCEL_INVITE_WORD".localized()
  
}
