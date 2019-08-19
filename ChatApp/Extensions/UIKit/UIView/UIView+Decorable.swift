//
//  UIView+Decorable.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 14/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit.UIView

extension UIView {
  
  func decorate<D: Decorable>(with decorator: D) {
    guard let view = self as? D.View else {
      return
    }
    
    decorator.decorate(view: view)
  }
  
}
