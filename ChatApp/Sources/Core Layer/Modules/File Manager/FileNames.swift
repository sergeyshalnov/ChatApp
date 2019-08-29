//
//  FileOperation.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 21/10/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit

enum FileName: String {
  case image = "profileImage.png"
  
  var value: String {
    return self.rawValue
  }
}
