//
//  CoreDataConfiguration.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 15/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation
import CoreData
import MultipeerConnectivity

protocol ICoreDataManager {
  
  func conversationFetchResultsController() -> NSFetchedResultsController<NSManagedObject>
  func messageFetchResultsController(conversationId: String) -> NSFetchedResultsController<Message>
  
  func delete(request: NSFetchRequest<NSManagedObject>, completion: @escaping (Bool) -> Void)
  func terminate()
  
}
