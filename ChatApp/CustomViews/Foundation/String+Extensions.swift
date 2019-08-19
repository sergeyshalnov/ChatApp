//
//  String+Extensions.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 30/06/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation

extension String {
  
  func localized() -> String {
    return NSLocalizedString(self, comment: "")
  }
  
  func substring(from index: Int) -> String {
    return String(self[self.index(startIndex, offsetBy: index)...])
  }
  
}


