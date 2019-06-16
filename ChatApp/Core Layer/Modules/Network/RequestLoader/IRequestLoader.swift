//
//  IRequestLoader.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 23/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation


protocol IRequestLoader {
  
  func load(url: String, completion: @escaping (Data?) -> Void)
  func cancel()
  
}
