//
//  CustomViewController.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 04/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit

protocol CustomViewController {
  associatedtype RootView: UIView
}

extension CustomViewController where Self: UIViewController {
  
  func view() -> RootView {
    guard let view = view as? RootView else {
      fatalError("ViewController doesn't specify with CustomViewController protocol")
    }
    
    return view
  }
  
}
