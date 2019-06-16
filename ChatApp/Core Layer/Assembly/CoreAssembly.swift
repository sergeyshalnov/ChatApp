//
//  CoreAssembly.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 15/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
  
  var communicationStorageManager: ICommunicationStorage { get }
  var profileStorageManager: IProfileStorage { get }
  
  var requestSender: IRequestSender { get }
  var requestLoader: IRequestLoader { get }
  
}

class CoreAssembly: ICoreAssembly {
  
  lazy var communicationStorageManager: ICommunicationStorage = CoreDataManager()
  lazy var profileStorageManager: IProfileStorage = CoreDataManager()
  lazy var requestSender: IRequestSender = RequestSender()
  lazy var requestLoader: IRequestLoader = RequestLoader()
  
}
