//
//  Message+TableViewCell.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 14/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation

extension Message {
  
  struct TableViewCell: ITableViewCell {
    
    var reuseIdentifier: String {
      return String(describing: MessageCell.self)
    }
    
  }
  
}
