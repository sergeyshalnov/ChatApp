//
//  ConversationData.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 15/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation

struct ConversationData {
  
  // MARK: - Variables
  
  let id: String
  let isUnread: Bool
  
  // MARK: - Init
  
  init(id: String, isUnread: Bool = false) {
    self.id = id
    self.isUnread = isUnread
  }
  
}
