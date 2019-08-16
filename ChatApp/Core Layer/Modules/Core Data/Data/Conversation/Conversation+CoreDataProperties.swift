//
//  Conversation+CoreDataProperties.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 09/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//
//

import Foundation
import CoreData
import MultipeerConnectivity.MCPeerID

extension Conversation {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Conversation> {
    return NSFetchRequest<Conversation>(entityName: "Conversation")
  }
  
  @NSManaged public var id: String
  @NSManaged public var user: User?
  @NSManaged public var messages: NSSet?
  @NSManaged public var isUnread: Bool
  
}

// MARK: Generated accessors for messages

extension Conversation {
  
  @objc(addMessagesObject:)
  @NSManaged public func addToMessages(_ value: Message)
  
  @objc(removeMessagesObject:)
  @NSManaged public func removeFromMessages(_ value: Message)
  
  @objc(addMessages:)
  @NSManaged public func addToMessages(_ values: NSSet)
  
  @objc(removeMessages:)
  @NSManaged public func removeFromMessages(_ values: NSSet)
  
}

extension Conversation {
  
  static var defaultSortDescriptors: [NSSortDescriptor] {
    let onlineSort = NSSortDescriptor(key: "user.isOnline", ascending: false)
    return [onlineSort]
  }
  
  static func conversationPredicate(id: String) -> NSPredicate {
    return NSPredicate(format: "id == %@", id)
  }
  
  static func predicate(peer: MCPeerID) -> NSPredicate {
    return NSPredicate(format: "user.peer == %@", peer)
  }
  
}

// MARK: - FetchRequest

extension Conversation {
  
  static func nonEmptyOnlineFetchRequest() -> NSFetchRequest<Conversation> {
    let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
    let predicate = NSPredicate(format: "user.isOnline == 1 AND messages.@count > 0")
    request.predicate = predicate
    return request
  }
  
  static func conversationFetchRequest(id: String) -> NSFetchRequest<Conversation> {
    let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
    let predicate = Conversation.conversationPredicate(id: id)
    request.predicate = predicate
    return request
  }
  
  static func fetchRequest(peer: MCPeerID) -> NSFetchRequest<Conversation> {
    let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
    let predicate = Conversation.predicate(peer: peer)
    
    request.predicate = predicate
    
    return request
  }
  
}