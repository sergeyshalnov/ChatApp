//
//  IImageManager.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 08/12/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation


protocol IImageManager: IImageDownloader {
  
  func performRequest(completion: @escaping (Int) -> Void)
  func webFormat(index: Int) -> String?
  
}
