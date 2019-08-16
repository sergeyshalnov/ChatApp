//
//  MessageData.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 15/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation


struct MessageModel: Codable {
  
  let id: String
  let text: String
  let date: Date
  let isIncoming: Bool
  
  init(id: String, text: String, date: Date = Date(), isIncoming: Bool) {
    self.id = id
    self.text = text
    self.date = date
    self.isIncoming = isIncoming
  }
  
}
