//
//  CommunicationStorageService.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation


protocol ICommunicationStorageService {
  
//  func add(user: UserData, completion: @escaping (String?) -> Void)
  func add(message: MessageModel)
  
  func offline(conversationId: String)
  func edit(conversation: ConversationData)
  func delete(conversationId: String)
  
}

class CommunicationStorageService: ICommunicationStorageService {
  
//  private var coreDataStorageManager: IStorageManager
//
//  init(coreDataStorageManager: IStorageManager) {
//    self.coreDataStorageManager = coreDataStorageManager
//  }
//
//  func add(user: UserData, completion: @escaping (String?) -> Void) {
//    coreDataStorageManager.add(user: user, completion: completion)
//  }
  
  func add(message: MessageModel) {
//    coreDataStorageManager.add(message: message)
  }
  
  func edit(conversation: ConversationData) {
//    coreDataStorageManager.edit(conversation: conversation)
  }
  
  func delete(conversationId: String) {
//    coreDataStorageManager.delete(conversation: conversationId)
  }
  
  func offline(conversationId: String) {
    //
  }
}
