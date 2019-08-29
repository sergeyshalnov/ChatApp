//
//  IPresentationAssembly.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 04/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit
import MultipeerConnectivity.MCSession

protocol IPresentationAssembly {
  
  func onboarding() -> UINavigationController
  func conversationsList() -> UINavigationController
  func conversation(_ conversation: Conversation, with session: MCSession) -> UIViewController
  func profile() -> UINavigationController
  func pixabay(for delegate: IImagePickerDelegate?) -> UIViewController 
  
}
