//
//  ServiceAssembly.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 15/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation
import MultipeerConnectivity.MCSession

protocol IServiceAssembly {
  
  func communicationService() -> ICommunicationService
  func profileStorageService() -> IProfileStorageService
  func pixabayService() -> IImageManager
  
  func storageService() -> IStorageService
  func messageService(session: MCSession) -> IMessageService
  
}

class ServiceAssembly: IServiceAssembly {
  
  private let coreAssembly: ICoreAssembly
  
  init(coreAssembly: ICoreAssembly) {
    self.coreAssembly = coreAssembly
  }
  
  func messageService(session: MCSession) -> IMessageService {
    return MessageService(session: session, messageStorage: coreAssembly.messageStorage)
  }
  
  func storageService() -> IStorageService {
    let storageService = StorageService(userStorage: coreAssembly.userStorage,
                                        conversationStorage: coreAssembly.conversationStorage,
                                        messageStorage: coreAssembly.messageStorage)
    
    return storageService
  }
  
  func communicationService() -> ICommunicationService {
    return CommunicationService(profileStorageService: profileStorageService(), dataParser: coreAssembly.dataParser())
  }
  
  func profileStorageService() -> IProfileStorageService {
    return ProfileStorageService(coreDataStorageManager: coreAssembly.profileStorageManager)
  }
  
  func pixabayService() -> IImageManager {
    return PixabayService(requestSender: coreAssembly.requestSender, requestLoader: coreAssembly.requestLoader)
  }
  
}
