//
//  String+Substring.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/06/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation

extension String {
  
  func substring(from index: Int) -> String {
    return String(self[self.index(startIndex, offsetBy: index)...])
  }
  
}
