//
//  Optional+Extensions.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 10/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
  func isEmpty() -> Bool {
    return self?.isEmpty ?? true
  }
}
