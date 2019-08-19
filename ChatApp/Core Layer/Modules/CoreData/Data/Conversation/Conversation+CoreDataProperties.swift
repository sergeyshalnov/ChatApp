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
  @NSManaged public var preview: MessageModel?
  @NSManaged public var messages: NSSet?
  @NSManaged public var isUnread: Bool
  
}

// MARK: - Generated accessors for messages

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

// MARK: - SortDescriptors

extension Conversation {
  
  static var defaultSortDescriptors: [NSSortDescriptor] {
    let onlineDescriptor = NSSortDescriptor(key: "user.isOnline", ascending: false)
    return [onlineDescriptor]
  }
  
}

// MARK: - Predicates

extension Conversation {
  
  static func predicate(id: String) -> NSPredicate {
    return NSPredicate(format: "id == %@", id)
  }
  
  static func predicate(peer: MCPeerID) -> NSPredicate {
    return NSPredicate(format: "user.peer == %@", peer)
  }
  
}

// MARK: - FetchRequest

extension Conversation {
  
  static func fetchRequest(id: String) -> NSFetchRequest<Conversation> {
    let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
    let predicate = Conversation.predicate(id: id)
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
