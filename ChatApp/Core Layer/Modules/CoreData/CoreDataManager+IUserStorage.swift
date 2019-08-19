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
  
  func edit(user: UserModel) {
    let context = CoreDataManager.container.viewContext
    let request = User.fetchRequest(peer: user.peer)
    
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
  
  func delete(user peer: MCPeerID) {
    let request = User.fetchRequest(peer: peer)
    
    delete(request: request) { success in
      #if DEBUG
        print("User delete : \(success)")
      #endif
    }
  }
  
}
