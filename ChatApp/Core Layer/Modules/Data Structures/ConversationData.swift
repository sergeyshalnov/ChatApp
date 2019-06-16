//
//  ConversationData.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 15/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation

struct ConversationData {
  
  let conversationId: String
  let wasUnreadMessages: Bool
  let lastMessage: String?
  let lastMessageDate: NSDate?
  
  init(conversationId: String, wasUnreadMessages: Bool = false, lastMessage: String? = nil, lastMessageDate: NSDate? = nil) {
    self.conversationId = conversationId
    self.wasUnreadMessages = wasUnreadMessages
    self.lastMessage = lastMessage
    self.lastMessageDate = lastMessageDate
  }
}
