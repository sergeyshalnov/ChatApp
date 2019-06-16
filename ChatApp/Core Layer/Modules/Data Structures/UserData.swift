//
//  UserData.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 15/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation


struct UserData {
  
  let username: String
  let online: Bool
  var userId: String
  
  init(username: String, online: Bool = true, userId: String = "") {
    self.username = username
    self.online = online
    self.userId = userId
  }
  
}
