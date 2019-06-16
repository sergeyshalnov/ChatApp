//
//  CoreDataManager+IMessageStorage.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/06/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation
import CoreData


// MARK: - IMessageStorage extension

extension CoreDataManager: IMessageStorage {
  
  func add(message: MessageData) {
    let context = CoreDataManager.container.viewContext
    
    context.performAndWait {
      do {
        let request = Conversation.conversationFetchRequest(id: message.conversationId)
        let conversations = try context.fetch(request)
        let conversation = conversations.first
        let entity = Message(context: context)
        
        entity.conversation = conversation
        entity.text = message.text
        entity.date = message.date
        entity.incoming = message.incoming
        entity.messageId = message.messageId
        
        conversation?.addToMessages(entity)
        conversation?.lastMessageDate = message.date
        conversation?.lastMessage = message.text
        
        try context.save()
      } catch {
        return
      }
    }
  }
  
}
