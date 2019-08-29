//
//  IConversationStorage.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 11/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation

protocol IConversationStorage {
  
  func edit(conversation: ConversationData)
  func delete(conversation: ConversationData)
  
}
