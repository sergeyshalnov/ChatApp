//
//  CoreDataManager.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 15/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit
import CoreData


// MARK: - Core Data Manager

class CoreDataManager: ICoreDataManager, ICommunicationStorage {
  
  static let container: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Model")
    container.loadPersistentStores(completionHandler: { _, _ in })
    return container
  }()
  
  func conversationFetchResultsController() -> NSFetchedResultsController<Conversation> {
    let fetchRequest = NSFetchRequest<Conversation>(entityName: String(describing: Conversation.self))
    
    fetchRequest.sortDescriptors = Conversation.defaultSortDescriptors
    fetchRequest.resultType = .managedObjectResultType
    
    let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                managedObjectContext: CoreDataManager.container.viewContext,
                                                sectionNameKeyPath: nil,
                                                cacheName: nil)
    
    return controller
  }
  
  func messageFetchResultsController(conversationId: String) -> NSFetchedResultsController<Message> {
    let fetchRequest = NSFetchRequest<Message>(entityName: String(describing: Message.self))
    
    fetchRequest.sortDescriptors = Message.defaultSortDescriptors
    fetchRequest.resultType = .managedObjectResultType
    fetchRequest.predicate = Message.defaultPredicate(conversationId: conversationId)
    
    let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                managedObjectContext: CoreDataManager.container.viewContext,
                                                sectionNameKeyPath: nil,
                                                cacheName: nil)
    
    return controller
  }
  
//  func delete(request: NSFetchRequest<NSFetchRequestResult>, completion: @escaping (Bool) -> Void) {
////    let delete = NSBatchDeleteRequest(fetchRequest: request)
//
//    let context = CoreDataManager.container.viewContext
//
//    context.perform {
//      do {
//        let items = try context.fetch(request)
//
//        for item in items {
//
//          context.delete(item)
//          //        try context.execute(delete)
//          try context.save()
//        }
//
//        completion(true)
//      } catch {
//        completion(false)
//      }
//    }
//  }
  
  func delete(request: NSFetchRequest<NSManagedObject>, completion: @escaping (Bool) -> Void) {
    let context = CoreDataManager.container.viewContext
    
    do {
      let items = try context.fetch(request)
      
      for item in items {
        context.delete(item)
        try context.save()
      }
      
      completion(true)
      
    } catch {
      print("Could not fetch. \(error), \(error.localizedDescription)")
      completion(false)
    }
    
  }
  
  func terminate() {
    let conversartionRequest = NSBatchDeleteRequest(fetchRequest: Conversation.fetchRequest())
    let userRequest = NSBatchDeleteRequest(fetchRequest: User.fetchRequest())
    let messageRequest = NSBatchDeleteRequest(fetchRequest: Message.fetchRequest())
    
    let context = CoreDataManager.container.viewContext
    
    context.performAndWait {
      do {
        try context.execute(conversartionRequest)
        try context.execute(userRequest)
        try context.execute(messageRequest)
        try context.save()
      } catch {
        return
      }
    }
    
  }
  
}
