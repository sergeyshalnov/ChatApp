//
//  CoreDataManager+IMessageStorage.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/06/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation
import CoreData
import MultipeerConnectivity.MCPeerID

// MARK: - IMessageStorage

extension CoreDataManager: IMessageStorage {
  
  func add(message: MessageModel, from peer: MCPeerID) {
    let context = CoreDataManager.container.viewContext
    
    context.performAndWait {
      do {
        let request = Conversation.fetchRequest(peer: peer)
        let conversations = try context.fetch(request)
        let conversation = conversations.first
        let entity = Message(context: context)
        
        entity.conversation = conversation
        entity.text = message.text
        entity.date = message.date as NSDate
        entity.isIncoming = message.isIncoming
        entity.id = message.id
        
        conversation?.addToMessages(entity)
        conversation?.preview = entity
        
        try context.save()
      } catch {
        return
      }
    }
  }
  
}
