//
//  Message+CoreDataProperties.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 09/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation
import CoreData

extension Message {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
    return NSFetchRequest<Message>(entityName: "Message")
  }
  
  @NSManaged public var conversation: Conversation?
  @NSManaged public var id: String?
  @NSManaged public var date: NSDate?
  @NSManaged public var text: String?
  @NSManaged public var isIncoming: Bool
  
}

// MARK: - SortDescriptors

extension Message {
  
  static var defaultSortDescriptors: [NSSortDescriptor] {
    let dateSort = NSSortDescriptor(key: "date", ascending: false)
    return [dateSort]
  }
  
}

// MARK: - Predicates

extension Message {
  
  static func predicate(conversation: Conversation) -> NSPredicate {
    return NSPredicate(format: "conversation.id == %@", conversation.id)
  }
  
}
