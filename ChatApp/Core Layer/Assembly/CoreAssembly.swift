//
//  CoreAssembly.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 15/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation

final class CoreAssembly: ICoreAssembly {
  
  // MARK: - Variables
  
  lazy var conversationStorage: IConversationStorage = CoreDataManager()
  lazy var profileStorageManager: IProfileStorage = CoreDataManager()
  lazy var messageStorage: IMessageStorage = CoreDataManager()
  lazy var userStorage: IUserStorage = CoreDataManager()
  
  lazy var requestSender: IRequestSender = RequestSender()
  lazy var requestLoader: IRequestLoader = RequestLoader()
  
  // MARK: - Functions
  
  func dataParser<Model: Codable>() -> DataParser<Model> {
    return DataParser<Model>()
  }
  
}
