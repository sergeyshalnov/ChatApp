//
//  UITextField+Extension.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 07/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit.UITextField

extension UITextField {
  
  @IBInspectable var xibPlaceholderLocalizableKey: String? {
    get {
      return nil
    }
    set(key) {
      placeholder = key?.localized()
    }
  }
  
}
