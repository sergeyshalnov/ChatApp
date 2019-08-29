//
//  IImagePickerDelegate.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 18/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit.UIImage

protocol IImagePickerDelegate: class {
  
  func update(with image: UIImage?)
  
}
