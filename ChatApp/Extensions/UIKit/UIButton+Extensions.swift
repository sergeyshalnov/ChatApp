//
//  UIButton+Extension.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 07/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit.UIButton

extension UIButton {
  
  @IBInspectable var xibLocalizableKey: String? {
    get {
      return nil
    }
    set(key) {
      setTitle(key?.localized(), for: .normal)
      setTitle(key?.localized(), for: .disabled)
    }
  }
  
}
