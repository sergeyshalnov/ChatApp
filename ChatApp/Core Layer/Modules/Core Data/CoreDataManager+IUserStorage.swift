//
//  CoreDataManager+IUserStorage.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/06/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation
import CoreData


// MARK: - IUserStorage extension

extension CoreDataManager: IUserStorage {
  
  func add(user: UserData, completion: @escaping (String?) -> Void) {
    
    let online = user.online
    let name = user.username
    
    let context = CoreDataManager.container.viewContext
    do {
      let conversation = Conversation(context: context)
      let user = User(context: context)
      
      user.conversation = conversation
      user.name = name
      user.online = online
      user.userId = "U" + Generator.id()
      
      conversation.user = user
      conversation.conversationId = "C" + Generator.id()
      
      try context.save()
      
      completion(conversation.conversationId)
    } catch {
      completion(nil)
      return
    }
    
  }
  
  func delete(userId: String) {
    let dataManager = CoreDataManager()
    
    //    let request: NSFetchRequest<NSFetchRequestResult> = User.fetchRequest()
    let request = NSFetchRequest<NSManagedObject>(entityName: "User")
    let predicate = User.userPredicate(id: userId)
    request.predicate = predicate
    
    dataManager.delete(request: request) { success in
      print("User delete : \(success)")
    }
  }
  
}
