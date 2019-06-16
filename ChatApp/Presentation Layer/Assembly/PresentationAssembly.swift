//
//  PresentationAssembly.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 15/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit

protocol IPresentationAssembly {
  
  func conversationsListViewController() -> UINavigationController
  
  func conversationViewController(title: String?, conversationId: String, conversationListDelegate: ConversationListDelegate) -> ConversationViewController
  
  func profileViewController() -> ProfileViewController
  
  func editProfileViewController(temporaryProfileImage: UIImage?) -> EditProfileViewController
  
  func imagesViewController(imageDelegate: ImageDelegate) -> ImagesViewController
  
}

class PresentationAssembly: IPresentationAssembly {
  
  private let serviceAssembly: IServiceAssembly
  
  init(serviceAssembly: IServiceAssembly) {
    self.serviceAssembly = serviceAssembly
  }
  
  func conversationsListViewController() -> UINavigationController {
    let coreData: ICoreDataManager = CoreDataManager()
    let navigator = UINavigationController()
    let controller = ConversationsListViewController(presentationAssembly: self, communicationService: serviceAssembly.communicationService(username: "Sergey Shalnov"), communicationStorageService: serviceAssembly.communicationStorageService(), profileStorageService: serviceAssembly.profileStorageService(), conversationFetchResultsController: coreData.conversationFetchResultsController())
    
    navigator.viewControllers = [controller]
    
    return navigator
  }
  
  func conversationViewController(title: String?, conversationId: String, conversationListDelegate: ConversationListDelegate) -> ConversationViewController {
    
    let coreData: ICoreDataManager = CoreDataManager()
    
    let controller = ConversationViewController(title: title, currentConversation: conversationId, conversationListDelegate: conversationListDelegate, presentationAssembly: self, communicationStorageService: serviceAssembly.communicationStorageService(), messageFetchResultsController: coreData.messageFetchResultsController(conversationId: conversationId))
    
    return controller
  }
  
  func profileViewController() -> ProfileViewController {
    let controller = ProfileViewController(presentationAssembly: self, profileStorageService: serviceAssembly.profileStorageService())
    
    return controller
  }
  
  func editProfileViewController(temporaryProfileImage: UIImage?) -> EditProfileViewController {
    let controller = EditProfileViewController(presentationAssembly: self, profileStorageService: serviceAssembly.profileStorageService(), temporaryProfileImage: temporaryProfileImage)
    
    return controller
  }
  
  func imagesViewController(imageDelegate: ImageDelegate) -> ImagesViewController {
    let controller = ImagesViewController(presentationAssembly: self, pixabayService: serviceAssembly.pixabayService(), imageDelegate: imageDelegate)
    
    return controller
  }
  
}
