//
//  ICoreAssembly.swift
//  ChatApp
//
//  Created by Шальнов Сергей Сергеевич on 19/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
  
  var conversationStorage: IConversationStorage { get }
  var profileStorageManager: IProfileStorage { get }
  var messageStorage: IMessageStorage { get }
  var userStorage: IUserStorage { get }
  
  var requestSender: IRequestSender { get }
  var requestLoader: IRequestLoader { get }
  
  func dataParser<Model: Codable>() -> DataParser<Model>
  
}
