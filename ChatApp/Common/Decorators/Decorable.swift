//
//  Decorable.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 14/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit.UIView

protocol Decorable {
  associatedtype View: UIView
  
  func decorate(view: View)
  
}
