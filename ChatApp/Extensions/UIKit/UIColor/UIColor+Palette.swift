//
//  UIColor+Palette.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 07/10/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit


// MARK: - Palette extension

extension UIColor {
  
  enum Palette {
    enum Blue {
      static let online = UIColor.init(hex: "#F1F6FE")
      static let bubble = UIColor.init(hex: "#4E9FF5")
    }
    enum Grey {
      static let textField = UIColor.init(hex: "#8E8E93", alpha: 0.12)
      static let placeholder = UIColor.init(hex: "#B4B4BA")
      static let bubble = UIColor.init(hex: "#D2D2D6")
    }
  }
  
}
