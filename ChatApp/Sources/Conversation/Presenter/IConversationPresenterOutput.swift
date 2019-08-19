//
//  IConversationPresenterOutput.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 11/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import UIKit.UIAlertController

protocol IConversationPresenterOutput: class {
  
  func disconnected(from conversation: Conversation)
  
}
