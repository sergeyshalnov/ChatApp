//
//  CoreDataManager+IConversationStorage.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/06/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation
import CoreData


// MARK: - IConversationStorage

extension CoreDataManager: IConversationStorage {
  
  func edit(conversation: ConversationData) {
    let context = CoreDataManager.container.viewContext
    
    context.performAndWait {
      do {
        let request = Conversation.conversationFetchRequest(id: conversation.conversationId)
        let conversations = try context.fetch(request)
        let entity = conversations.first
        
        entity?.wasUnreadMessages = conversation.wasUnreadMessages
        
        if conversation.lastMessage != nil && conversation.lastMessageDate != nil {
          entity?.lastMessage = conversation.lastMessage
          entity?.lastMessageDate = conversation.lastMessageDate
        }
        
        try context.save()
        
      } catch {
        print(error.localizedDescription)
      }
    }
    
  }
  
  func delete(conversationId: String) {
    let DataManager: ICoreDataManager = CoreDataManager()
    //    let request: NSFetchRequest<NSFetchRequestResult> = Conversation.fetchRequest()
    let request = NSFetchRequest<NSManagedObject>(entityName: "Conversation")
    let predicate = Conversation.conversationPredicate(id: conversationId)
    request.predicate = predicate
    
    DataManager.delete(request: request) { success in
      print("Conversation delete : \(success)")
    }
  }
  
}
