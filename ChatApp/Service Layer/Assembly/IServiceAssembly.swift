//
//  IServiceAssembly.swift
//  ChatApp
//
//  Created by Шальнов Сергей Сергеевич on 19/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
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
