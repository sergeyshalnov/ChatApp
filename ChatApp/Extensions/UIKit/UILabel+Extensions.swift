//
//  UILabel+Extensions.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 17/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit.UILabel

extension UILabel {
  
  @IBInspectable var xibLabelLocalizableKey: String? {
    get {
      return nil
    }
    set(key) {
      text = key?.localized()
    }
  }
  
  func size() -> CGSize? {
    guard let text = text else {
      return nil
    }
    
    let attributes = [NSAttributedString.Key.font: font as Any]
    return (text as NSString).size(withAttributes: attributes)
  }
  
}
