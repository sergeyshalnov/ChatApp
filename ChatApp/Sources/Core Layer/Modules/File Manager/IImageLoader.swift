//
//  IImageLoader.swift
//  ChatApp
//
//  Created by Шальнов Сергей Сергеевич on 19/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit.UIImage

protocol IImageLoader {
  
  func load(filename: String) -> UIImage?
  
}
