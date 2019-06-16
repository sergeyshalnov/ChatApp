//
//  UIColor+Hex.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 15/06/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit.UIColor


// MARK: - Hex extension

extension UIColor {
  
  convenience init(hex: UInt64, alpha: CGFloat = 1) {
    let red = CGFloat((hex >> 16) & 0xff) / 255
    let green = CGFloat((hex >> 8) & 0xff) / 255
    let blue = CGFloat(hex & 0xff) / 255
    
    print(red, green, blue)
    
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
  
  convenience init(hex: String, alpha: CGFloat = 1) {
    var hex = hex
    
    if hex.hasPrefix("#") {
      hex = hex.substring(from: 1)
    }
    
    let scanner = Scanner(string: hex)
    var value = UInt64(0)
    
    guard scanner.scanHexInt64(&value) else {
      fatalError()
    }
    
    self.init(hex: value, alpha: alpha)
  }
  
}
