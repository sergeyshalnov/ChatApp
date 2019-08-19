//
//  CoreDataManager.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 15/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit
import CoreData

final class CoreDataManager: ICoreDataManager {
  
  // MARK: - Variables
  
  private(set) static var container = makeContainer()
  
  private static func makeContainer() -> NSPersistentContainer {
    let container = NSPersistentContainer(name: "Model")
    container.loadPersistentStores(completionHandler: { _, _ in })
    return container
  }
  
}

// MARK: - Fetched Results Controllers

extension CoreDataManager {
  
  func conversationFetchedResultsController() -> NSFetchedResultsController<NSManagedObject> {
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: String(describing: Conversation.self))
    
    fetchRequest.sortDescriptors = Conversation.defaultSortDescriptors
    fetchRequest.resultType = .managedObjectResultType
    
    let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                managedObjectContext: CoreDataManager.container.viewContext,
                                                sectionNameKeyPath: nil,
                                                cacheName: nil)
    
    return controller
  }
  
  func messageFetchedResultsController(conversation: Conversation) -> NSFetchedResultsController<NSManagedObject> {
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: String(describing: Message.self))
    
    fetchRequest.predicate = Message.predicate(conversation: conversation)
    fetchRequest.sortDescriptors = Message.defaultSortDescriptors
    fetchRequest.resultType = .managedObjectResultType
    
    let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                managedObjectContext: CoreDataManager.container.viewContext,
                                                sectionNameKeyPath: nil,
                                                cacheName: nil)
    
    return controller
  }
  
}

// MARK: - Functions

extension CoreDataManager {
  
  func delete<T: NSManagedObject>(request: NSFetchRequest<T>, completion: @escaping (Bool) -> Void) {
    let context = CoreDataManager.container.viewContext
    
    do {
      let items = try context.fetch(request)
      
      for item in items {
        context.delete(item)
        try context.save()
      }
      
      completion(true)
      
    } catch {
      #if DEBUG
      print("Error on delete NSManagedObject: \(error.localizedDescription)")
      #endif
      
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
