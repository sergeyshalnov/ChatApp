//
//  User+CoreDataProperties.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 11/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//
//

import Foundation
import CoreData


extension User {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
    return NSFetchRequest<User>(entityName: "User")
  }
  
  @NSManaged public var userId: String?
  @NSManaged public var name: String?
  @NSManaged public var online: Bool
  @NSManaged public var conversation: Conversation?
  
}

extension User {
  static var defaultSortDescriptors: [NSSortDescriptor] {
    let onlineSort = NSSortDescriptor(key: "online", ascending: false)
    // let nameSort = NSSortDescriptor(key: "name", ascending: true)
    return [onlineSort]
  }
}

extension User {
  
  static func userPredicate(id: String) -> NSPredicate {
    return NSPredicate(format: "userId == %@", id)
  }
  
}

extension User {
  
  static func userFetchRequest(id: String) -> NSFetchRequest<User> {
    let request: NSFetchRequest<User> = User.fetchRequest()
    let predicate = userPredicate(id: id)
    request.predicate = predicate
    return request
  }
  
  static func onlineUsersFetchRequest() -> NSFetchRequest<User> {
    let request: NSFetchRequest<User> = User.fetchRequest()
    let predicate = NSPredicate(format: "online == 1")
    request.predicate = predicate
    return request
  }
}
