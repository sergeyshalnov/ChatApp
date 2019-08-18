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
  
  func profileViewController() -> ProfileViewController1
  func editProfileViewController(temporaryProfileImage: UIImage?) -> EditProfileViewController
  func imagesViewController(imageDelegate: ImageDelegate) -> ImagesViewController
  
}
