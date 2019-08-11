//
//  Message+CoreDataProperties.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 09/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//
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

extension Message {
  
  static var defaultSortDescriptors: [NSSortDescriptor] {
    let dateSort = NSSortDescriptor(key: "date", ascending: false)
    return [dateSort]
  }
  
  static func defaultPredicate(conversationId: String) -> NSPredicate {
    let conversationPredicate = NSPredicate(format: "conversation.id == %@", conversationId)
    return conversationPredicate
  }
  
}

extension Message {
  
  func messagesFetchRequest(conversationId: String) -> NSFetchRequest<Message> {
    let request: NSFetchRequest<Message> = Message.fetchRequest()
    let predicate = NSPredicate(format: "conversation.id == %@", conversationId)
    request.predicate = predicate
    return request
  }
}
