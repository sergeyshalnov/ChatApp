//
//  CoreAssembly.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 15/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
  
//  var communicationStorageManager: IStorageManager { get }
  var profileStorageManager: IProfileStorage { get }
  
  var requestSender: IRequestSender { get }
  var requestLoader: IRequestLoader { get }
  
  var userStorage: IUserStorage { get }
  var conversationStorage: IConversationStorage { get }
  var messageStorage: IMessageStorage { get }
  
}

class CoreAssembly: ICoreAssembly {
  
  lazy var userStorage: IUserStorage = CoreDataManager()
  lazy var conversationStorage: IConversationStorage = CoreDataManager()
  lazy var messageStorage: IMessageStorage = CoreDataManager()
  
//  lazy var communicationStorageManager: IStorageManager = CoreDataManager()
  lazy var profileStorageManager: IProfileStorage = CoreDataManager()
  lazy var requestSender: IRequestSender = RequestSender()
  lazy var requestLoader: IRequestLoader = RequestLoader()
  
  
  
}
