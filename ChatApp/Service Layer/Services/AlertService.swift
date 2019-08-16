//
//  AlertService.swift
//  ChatApp
//
//  Created by Шальнов Сергей Сергеевич on 16/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit.UIAlertController


final class AlertService: IAlertService {
  
  func controller(title: String?, message: String?, actions: () -> [UIAlertAction]) -> UIAlertController {
    let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let actions = actions()
    
    for action in actions {
      controller.addAction(action)
    }
    
    return controller
  }
  
}
