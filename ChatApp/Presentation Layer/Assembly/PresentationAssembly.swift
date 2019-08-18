//
//  PresentationAssembly.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 15/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit
import MultipeerConnectivity.MCSession

class PresentationAssembly {
  
  // MARK: - Assembly
  
  private let serviceAssembly: IServiceAssembly
  
  // MARK: - Init
  
  init(serviceAssembly: IServiceAssembly) {
    self.serviceAssembly = serviceAssembly
  }
  
}

// MARK: - IPresentationAssembly

extension PresentationAssembly: IPresentationAssembly {
  
  func onboarding() -> UIViewController {
    let controller = OnboardingViewController()
    let userDefaultsService = serviceAssembly.userDefaultsService()
    let profileStorageService = serviceAssembly.profileStorageService()
    
    let router = OnboardingRouter(view: controller)
    let presenter = OnboardingPresenter(output: controller,
                                        userDefaultsService: userDefaultsService,
                                        profileStorageService: profileStorageService)
    
    controller.output = presenter
    controller.router = router
    
    return controller
  }
  
  func conversationsList() -> UINavigationController {
    let controller = ConversationsListViewController()
    let fetchedResultsController = CAFetchedResultsController(CoreDataManager().conversationFetchResultsController(),
                                                              for: controller.view().conversationsTableView)
    
    let communicationService = serviceAssembly.communicationService(username: "TEST")
    let communicationController = CACommunicationController(communicationService: communicationService,
                                                            storageService: serviceAssembly.storageService())
    let router = ConversationsListRouter(view: controller, presentationAssembly: self)
    let presenter = ConversationsListPresenter(output: controller,
                                               fetchedResultsController: fetchedResultsController,
                                               communicationController: communicationController)
    
    controller.output = presenter
    controller.router = router
    
    return UINavigationController(rootViewController: controller)
  }
  
  func conversation(_ conversation: Conversation, with session: MCSession) -> UIViewController {
    let controller = ConversationViewController()
    let messageService = serviceAssembly.messageService(session: session)
    let messageFetchResultsController = CoreDataManager().messageFetchResultsController(conversation: conversation)
    let fetchedResultsController = CAFetchedResultsController(messageFetchResultsController, for: controller.view().tableView)
    
    let router = ConversationRouter(view: controller)
    let presenter = ConversationPresenter(output: controller,
                                          conversation: conversation,
                                          fetchedResultsController: fetchedResultsController,
                                          messageService: messageService)
    
    
    controller.navigationItem.title = conversation.user?.peer?.displayName
    controller.output = presenter
    controller.router = router
    
    return controller
  }
  
  func profile() -> ProfileViewController {
    let controller = ProfileViewController()
    let router = ProfileRouter(view: controller)
    let presenter = ProfilePresenter(output: controller,
                                     profileStorageService: serviceAssembly.profileStorageService())
    
    controller.output = presenter
    controller.router = router
    
    return controller
  }
  
  // TODO: - Refactoring
  
  func profileViewController() -> ProfileViewController1 {
    let controller = ProfileViewController1(presentationAssembly: self, profileStorageService: serviceAssembly.profileStorageService())
    
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
