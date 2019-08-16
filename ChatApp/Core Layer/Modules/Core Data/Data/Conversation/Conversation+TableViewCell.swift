//
//  Conversation+TableViewCell.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 09/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation

extension Conversation {
  
  struct TableViewCell: ITableViewCell {
    
    var reuseIdentifier: String {
      return String(describing: ConversationCell.self)
    }
    
  }
  
}
