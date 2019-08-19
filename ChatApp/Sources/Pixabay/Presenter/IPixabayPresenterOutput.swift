//
//  IPixabayPresenterOutput.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 18/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import UIKit.UIImage

protocol IPixabayPresenterOutput: class {
  
  func updateView()
  func display(image: UIImage?)
  
}
