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


extension Conversation {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Conversation> {
    return NSFetchRequest<Conversation>(entityName: "Conversation")
  }
  
  @NSManaged public var conversationId: String?
  @NSManaged public var user: User?
  @NSManaged public var messages: NSSet?
  @NSManaged public var wasUnreadMessages: Bool
  
  @NSManaged public var lastMessage: String?
  @NSManaged public var lastMessageDate: NSDate?
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
    let onlineSort = NSSortDescriptor(key: "user.online", ascending: false)
    let nameSort = NSSortDescriptor(key: "user.name", ascending: true)
    let dateSort = NSSortDescriptor(key: "lastMessageDate", ascending: false)
    return [onlineSort, dateSort, nameSort]
  }
  
  static func conversationPredicate(id: String) -> NSPredicate {
    return NSPredicate(format: "conversationId == %@", id)
  }
  
}

// MARK: - FetchRequest

extension Conversation {
  
  static func nonEmptyOnlineFetchRequest() -> NSFetchRequest<Conversation> {
    let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
    let predicate = NSPredicate(format: "user.online == 1 AND messages.@count > 0")
    request.predicate = predicate
    return request
  }
  
  static func conversationFetchRequest(id: String) -> NSFetchRequest<Conversation> {
    let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
    let predicate = Conversation.conversationPredicate(id: id)
    request.predicate = predicate
    return request
  }
}
