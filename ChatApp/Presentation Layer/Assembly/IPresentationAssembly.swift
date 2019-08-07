//
//  IPresentationAssembly.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 04/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit

protocol IPresentationAssembly {
  
  func onboarding() -> UIViewController
  func conversationsListViewController() -> UINavigationController
  func conversationViewController(title: String?, conversationId: String, conversationListDelegate: ConversationListDelegate) -> ConversationViewController
  func profileViewController() -> ProfileViewController
  func editProfileViewController(temporaryProfileImage: UIImage?) -> EditProfileViewController
  func imagesViewController(imageDelegate: ImageDelegate) -> ImagesViewController
  
}
