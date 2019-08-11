//
//  ITableViewModelRepresentable.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 09/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation

protocol ITableViewModelRepresentable {
  
  func updateContent(with model: ITableViewModel)
  
}
