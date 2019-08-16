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
  
  func onboarding() -> UIViewController
  func conversationsList() -> UINavigationController
  func conversation(_ conversation: Conversation, with session: MCSession) -> UIViewController
  
//  func conversationViewController(title: String?, conversationId: String, conversationListDelegate: ConversationListDelegate) -> ConversationViewController
  func profileViewController() -> ProfileViewController
  func editProfileViewController(temporaryProfileImage: UIImage?) -> EditProfileViewController
  func imagesViewController(imageDelegate: ImageDelegate) -> ImagesViewController
  
}
