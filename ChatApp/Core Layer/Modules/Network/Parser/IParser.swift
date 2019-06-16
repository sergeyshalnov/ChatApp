//
//  IParser.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 22/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation


protocol IParser {
  associatedtype Model
  
  func parse(data: Data) -> Model?
}
