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
  
  func onboarding() -> UINavigationController {
    let profileStorageService = serviceAssembly.profileStorageService()
    let controller = OnboardingViewController()
    let router = OnboardingRouter(view: controller)
    let presenter = OnboardingPresenter(output: controller, profileStorageService: profileStorageService)
    
    controller.output = presenter
    controller.router = router
    
    let navigationController = UINavigationController(rootViewController: controller)
    
    navigationController.navigationBar.shadowImage = UIImage()
    
    return navigationController
  }
  
  func conversationsList() -> UINavigationController {
    let controller = ConversationsListViewController()
    let fetchedResultsController = CAFetchedResultsController(CoreDataManager().conversationFetchResultsController(),
                                                              for: controller.view().conversationsTableView)
    
    let communicationService = serviceAssembly.communicationService()
    let communicationController = CACommunicationController(communicationService: communicationService,
                                                            storageService: serviceAssembly.storageService())
    let router = ConversationsListRouter(view: controller, presentationAssembly: self)
    let presenter = ConversationsListPresenter(output: controller,
                                               fetchedResultsController: fetchedResultsController,
                                               communicationController: communicationController)
    
    controller.output = presenter
    controller.router = router
    
    let navigationController = UINavigationController(rootViewController: controller)
    
    navigationController.navigationBar.shadowImage = UIImage()
    
    return navigationController
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
  
  func profile() -> UINavigationController {
    let controller = ProfileViewController()
    let router = ProfileRouter(view: controller, presentationAssembly: self)
    let presenter = ProfilePresenter(output: controller,
                                     profileStorageService: serviceAssembly.profileStorageService())
    
    controller.output = presenter
    controller.router = router
    
    let navigationController = UINavigationController(rootViewController: controller)
    
    navigationController.navigationBar.shadowImage = UIImage()
    
    return navigationController
  }
  
  func pixabay(for delegate: IImagePickerDelegate?) -> UIViewController {
    let controller = PixabayViewController()
    let presenter = PixabayPresenter(output: controller, imageManager: serviceAssembly.pixabayService())
    let router = PixabayRouter(view: controller)
    
    controller.output = presenter
    controller.router = router
    
    controller.navigationItem.title = "PIXABAY"
    controller.view().imagesCollectionView.delegate = presenter
    controller.view().imagesCollectionView.dataSource = presenter
    controller.delegate = delegate
    
    let navigationController = UINavigationController(rootViewController: controller)
    
    navigationController.navigationBar.shadowImage = UIImage()
    
    return navigationController
  }
  
}
