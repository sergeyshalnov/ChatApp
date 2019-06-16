//
//  ServiceAssembly.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 15/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation

protocol IServiceAssembly {
  
  func communicationService(username: String) -> ICommunicationService
  func communicationStorageService() -> ICommunicationStorageService
  func profileStorageService() -> IProfileStorageService
  func pixabayService() -> IImageManager
  
}

class ServiceAssembly: IServiceAssembly {
  
  private let coreAssembly: ICoreAssembly
  
  init(coreAssembly: ICoreAssembly) {
    self.coreAssembly = coreAssembly
  }
  
  func communicationService(username: String) -> ICommunicationService {
    return CommunicationService(username: username)
  }
  
  func communicationStorageService() -> ICommunicationStorageService {
    return CommunicationStorageService(coreDataStorageManager: coreAssembly.communicationStorageManager)
  }
  
  func profileStorageService() -> IProfileStorageService {
    return ProfileStorageService(coreDataStorageManager: coreAssembly.profileStorageManager)
  }
  
  func pixabayService() -> IImageManager {
    return PixabayService(requestSender: coreAssembly.requestSender, requestLoader: coreAssembly.requestLoader)
  }
  
}
