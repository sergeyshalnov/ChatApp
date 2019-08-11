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

// MARK: - IMessageStorage extension

extension CoreDataManager: IMessageStorage {
  
  func add(message: MessageData, from peer: MCPeerID) {
    let context = CoreDataManager.container.viewContext
    
    context.performAndWait {
      do {
//        let request = Conversation.conversationFetchRequest(id: message.conversationIdentifier)
        let request = Conversation.fetchRequest(peer: peer)
        let conversations = try context.fetch(request)
        let conversation = conversations.first
        let entity = Message(context: context)
        
        entity.conversation = conversation
        entity.text = message.text
        entity.date = message.date
        entity.isIncoming = message.isIncoming
        entity.id = message.id
        
        conversation?.addToMessages(entity)
//        conversation?.lastMessageDate = message.date
//        conversation?.lastMessage = message.text
        
        try context.save()
      } catch {
        return
      }
    }
  }
  
}
