//
//  IAlertService.swift
//  ChatApp
//
//  Created by Шальнов Сергей Сергеевич on 16/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit.UIAlertController

protocol IAlertService {
  
  func controller(title: String?, message: String?, actions: () -> [UIAlertAction]) -> UIAlertController
  
}
