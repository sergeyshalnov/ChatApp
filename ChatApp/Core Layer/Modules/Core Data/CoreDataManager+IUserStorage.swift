//
//  CoreDataManager+IUserStorage.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/06/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation
import CoreData
import MultipeerConnectivity

// MARK: - IUserStorage extension

extension CoreDataManager: IUserStorage {
  
  func user(by peer: MCPeerID) -> User? {
    let context = CoreDataManager.container.newBackgroundContext()
    let request = NSFetchRequest<User>(entityName: "User")
    let predicate = User.predicate(peer: peer)
    
    request.predicate = predicate
    
    do {
      let items = try context.fetch(request)
      
      return items.first
    } catch {
      return nil
    }
  }
  
  func users() -> [User] {
    let context = CoreDataManager.container.newBackgroundContext()
    let request = NSFetchRequest<User>(entityName: "User")
    
    return (try? context.fetch(request)) ?? []
  }
  
  func add(user peer: MCPeerID) {
    let context = CoreDataManager.container.viewContext
    
    do {
      let conversation = Conversation(context: context)
      let user = User(context: context)
      
      user.peer = peer
      user.conversation = conversation
      user.isOnline = true
      user.id = "U" + Generator.id()
      
      conversation.user = user
      conversation.id = "C" + Generator.id()
      
      try context.save()
    } catch {
      return
    }
  }
  
  func edit(user: UserData) {
    let context = CoreDataManager.container.viewContext
    let request = NSFetchRequest<User>(entityName: "User")
//    let predicate = User.userPredicate(id: user.id)
    let predicate = User.predicate(peer: user.peer)
    
    request.predicate = predicate
    
    do {
      let items = try context.fetch(request)
      
      guard let item = items.first else {
        return
      }
      
      item.setValue(user.isOnline, forKey: "isOnline")
      item.setValue(user.isConfirmed, forKey: "isConfirmed")
      
      try context.save()
    } catch {
      #if DEBUG
        print(error.localizedDescription)
      #endif
    }
  }
  
  func offline(user id: String) {
    let context = CoreDataManager.container.viewContext
    let request = NSFetchRequest<User>(entityName: "User")
    let predicate = User.userPredicate(id: id)
    
    request.predicate = predicate
    
    do {
      let items = try context.fetch(request)
      
      guard let item = items.first else {
        return
      }
      
      item.setValue(false, forKey: "online")
      
      try context.save()
    } catch {
      #if DEBUG
        print(error.localizedDescription)
      #endif
    }
    
  }
  
  func delete(user peer: MCPeerID) {
    let dataManager = CoreDataManager()
    let request = NSFetchRequest<NSManagedObject>(entityName: "User")
//    let predicate = User.userPredicate(id: user.id)
    let predicate = User.predicate(peer: peer)
    
    request.predicate = predicate
    
    dataManager.delete(request: request) { success in
      #if DEBUG
        print("User delete : \(success)")
      #endif
    }
  }
  
}
