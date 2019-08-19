//
//  ServiceAssembly.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 15/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation
import MultipeerConnectivity.MCSession

final class ServiceAssembly: IServiceAssembly {
  
  private let coreAssembly: ICoreAssembly
  
  init(coreAssembly: ICoreAssembly) {
    self.coreAssembly = coreAssembly
  }
  
  func messageService(session: MCSession) -> IMessageService {
    return MessageService(session: session, messageStorage: coreAssembly.messageStorage)
  }
  
  func storageService() -> IStorageService {
    return StorageService(userStorage: coreAssembly.userStorage,
                          conversationStorage: coreAssembly.conversationStorage,
                          messageStorage: coreAssembly.messageStorage)
  }
  
  func communicationService() -> ICommunicationService {
    return CommunicationService(profileStorageService: profileStorageService(),
                                dataParser: coreAssembly.dataParser())
  }
  
  func profileStorageService() -> IProfileStorageService {
    return ProfileStorageService(coreDataStorageManager: coreAssembly.profileStorageManager)
  }
  
  func pixabayService() -> IImageManager {
    return PixabayService(requestSender: coreAssembly.requestSender,
                          requestLoader: coreAssembly.requestLoader)
  }
  
}
