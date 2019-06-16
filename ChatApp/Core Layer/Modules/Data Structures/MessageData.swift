//
//  MessageData.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 15/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation


struct MessageData {
  
  let messageId: String
  let conversationId: String
  let text: String
  let date: NSDate
  let incoming: Bool
  
  init(messageId: String, conversationId: String, text: String, date: NSDate = NSDate(), incoming: Bool) {
    self.messageId = messageId
    self.conversationId = conversationId
    self.text = text
    self.date = date
    self.incoming = incoming
  }
  
}
