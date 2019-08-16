//
//  IConversationsListPresenterOutput.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 07/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import UIKit.UIAlertController
import MultipeerConnectivity.MCSession

protocol IConversationsListPresenterOutput: class {
  
  func display(alert: UIAlertController)
  func converse(in conversation: Conversation, with session: MCSession)
  
}
