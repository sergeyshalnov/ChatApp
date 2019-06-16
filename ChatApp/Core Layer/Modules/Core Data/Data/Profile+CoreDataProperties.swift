//
//  Profile+CoreDataProperties.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 09/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//
//

import Foundation
import CoreData


extension Profile {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
    return NSFetchRequest<Profile>(entityName: "Profile")
  }
  
  @NSManaged public var image: String?
  @NSManaged public var information: String?
  @NSManaged public var username: String?
  
}
