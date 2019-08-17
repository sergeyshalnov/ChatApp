//
//  ConversationPresenter.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 11/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import Foundation
import CoreData

final class ConversationPresenter {
  
  // MARK: - Variables
  
  private weak var output: IConversationPresenterOutput?
  private let fetchedResultsController: CAFetchedResultsController
  private let messageService: IMessageService
  private let conversation: Conversation
  private var observers: [Any] = []
  
  // MARK: - Init
  
  init(output: IConversationPresenterOutput,
       conversation: Conversation,
       fetchedResultsController: CAFetchedResultsController,
       messageService: IMessageService) {
    
    self.output = output
    self.conversation = conversation
    self.fetchedResultsController = fetchedResultsController
    self.messageService = messageService
    
    setup()
  }
  
  deinit {
    for observer in observers {
      NotificationCenter.default.removeObserver(observer)
    }
  }
  
}

// MARK: - Setup

private extension ConversationPresenter {
  
  func setup() {
    setupObserver()
  }
  
  func setupObserver() {
    let selector = #selector(managedObjectContextObjectsDidChange(_:))
    let name = NSNotification.Name.NSManagedObjectContextObjectsDidChange
    let object = conversation.managedObjectContext
    
    observers.append(NotificationCenter.default.addObserver(self, selector: selector, name: name, object: object))
  }
  
  @objc func managedObjectContextObjectsDidChange(_ notification: NSNotification) {
    guard let userInfo = notification.userInfo else {
      return
    }
    
    if let deletedObjects = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, deletedObjects.count > 0 {
      output?.disconnected(from: conversation)
    }
  }
  
}

// MARK: - IConversationPresenterInput

extension ConversationPresenter: IConversationPresenterInput {
  
  func performFetch() {
    fetchedResultsController.performFetch()
  }
  
  func send(message: String) {
    guard let peer = conversation.user?.peer else {
      return
    }
    
    messageService.send(message, to: peer)
  }
  
}
