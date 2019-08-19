//
//  Generator.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 18/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit

class Generator {
  
  static func id() -> String {
    guard let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString() else { fatalError("Can't generate identifier") }
    return string
  }
  
  static func number(from: CGFloat, to: CGFloat) -> CGFloat {
    return from + CGFloat(arc4random_uniform(UInt32(to - from + 1)))
  }
  
}
