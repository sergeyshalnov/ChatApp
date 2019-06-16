//
//  ConversationListCellConfiguration.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 07/10/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation

protocol ConversationListCellConfiguration : class {
  
  var name: String? {get set}
  var message: String? {get set}
  var date: Date? {get set}
  var online: Bool {get set}
  var wasUnreadMessages: Bool {get set}
  
}
