//
//  IConversationsListViewOutput.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 07/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import Foundation

protocol IConversationsListViewOutput {
  
  func performFetch()
  func selectedItem(at indexPath: IndexPath)
  
}
