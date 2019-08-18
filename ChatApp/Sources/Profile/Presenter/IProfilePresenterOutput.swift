//
//  IProfilePresenterOutput.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import UIKit

protocol IProfilePresenterOutput: class {
  
  func display(profile: ProfileData)
  func display(message: String, with actions: [UIAlertAction])
  
}
