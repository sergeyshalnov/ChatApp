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
        let request = Conversation.conversationFetchRequest(id: conversation.id)
        let conversations = try context.fetch(request)
        let entity = conversations.first
        
        entity?.isUnread = conversation.isUnread
        
        try context.save()
      } catch {
        #if DEBUG
          print(error.localizedDescription)
        #endif
      }
    }
    
  }
  
  func delete(conversation: ConversationData) {
    let DataManager: ICoreDataManager = CoreDataManager()
    let request = NSFetchRequest<NSManagedObject>(entityName: "Conversation")
    let predicate = Conversation.conversationPredicate(id: conversation.id)
    request.predicate = predicate
    
    DataManager.delete(request: request) { success in
      #if DEBUG
        print("Conversation delete : \(success)")
      #endif
    }
  }
  
}
