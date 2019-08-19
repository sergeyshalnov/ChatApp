//
//  UIViewController+Alert.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 17/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit.UIViewController

extension UIViewController {
  
  func alert(title: String?,
             message: String?,
             preferredStyle: UIAlertController.Style = .alert,
             actions: [UIAlertAction]) {
    
    let controller = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
    
    for action in actions {
      controller.addAction(action)
    }
    
    present(controller, animated: true)
  }
  
}
