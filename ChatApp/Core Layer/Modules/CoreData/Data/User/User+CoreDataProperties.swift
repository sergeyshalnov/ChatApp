//
//  User+CoreDataProperties.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 11/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//
//

import Foundation
import MultipeerConnectivity.MCPeerID
import CoreData

extension User {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
    return NSFetchRequest<User>(entityName: "User")
  }
  
  @NSManaged public var id: String?
  @NSManaged public var peer: MCPeerID?
  @NSManaged public var conversation: Conversation?
  @NSManaged public var isOnline: Bool
  @NSManaged public var isConfirmed: Bool
  
}

// MARK: - SortDescriptors

extension User {
  
  static var defaultSortDescriptors: [NSSortDescriptor] {
    let onlineSort = NSSortDescriptor(key: "isOnline", ascending: false)
//    let dateSort = NSSortDescriptor(key: "conversation", ascending: false)
    return [onlineSort]
  }
  
}

// MARK: - Predicates

extension User {
  
  static func predicate(id: String) -> NSPredicate {
    return NSPredicate(format: "id == %@", id)
  }
  
  static func predicate(peer: MCPeerID) -> NSPredicate {
    return NSPredicate(format: "peer == %@", peer)
  }
  
}

// MARK: - Fetch Requests

extension User {
  
  static func fetchRequest(peer: MCPeerID) -> NSFetchRequest<User> {
    let request: NSFetchRequest<User> = User.fetchRequest()
    let predicate = User.predicate(peer: peer)
    
    request.predicate = predicate
    
    return request
  }
  
}
