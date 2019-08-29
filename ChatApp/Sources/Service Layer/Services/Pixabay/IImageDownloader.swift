//
//  IImageDownloader.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 23/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit

protocol IImageDownloader {
  
  func load(url: String, completion: @escaping (UIImage?) -> Void)
  
}


