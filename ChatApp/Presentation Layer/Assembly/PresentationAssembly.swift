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
    
    let communicationService = serviceAssembly.communicationService(username: "123")
    let communicationController = CACommunicationController(communicationService: communicationService,
                                                            storageService: serviceAssembly.storageService())
    let router = ConversationsListRouter(view: controller, presentationAssembly: self)
    let presenter = ConversationsListPresenter(output: controller,
                                               fetchedResultsController: fetchedResultsController,
                                               communicationController: communicationController,
                                               alertService: serviceAssembly.alertService())
    
    controller.output = presenter
    controller.router = router
    
    return UINavigationController(rootViewController: controller)
    
//    let coreData: ICoreDataManager = CoreDataManager()
//    let navigator = UINavigationController()
//    let username = UserDefaultsService().get(for: .username) ?? "Sergey Shalnov"
//
//    let controller = ConversationsListViewController(
//      presentationAssembly: self,
//      communicationService: serviceAssembly.communicationService(username: username),
//      communicationStorageService: serviceAssembly.communicationStorageService(),
//      profileStorageService: serviceAssembly.profileStorageService(),
//      conversationFetchResultsController: coreData.conversationFetchResultsController())
//
//    navigator.viewControllers = [controller]
//
//    return navigator
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
    
    
    controller.output = presenter
    controller.router = router
    
    return controller
  }
  
//  func conversationViewController(title: String?, conversationId: String, conversationListDelegate: ConversationListDelegate) -> ConversationViewController {
//    fatalError()
////    let coreData: ICoreDataManager = CoreDataManager()
////
////    let controller = ConversationViewController(title: title, currentConversation: conversationId, conversationListDelegate: conversationListDelegate, presentationAssembly: self, communicationStorageService: serviceAssembly.communicationStorageService(), messageFetchResultsController: coreData.messageFetchResultsController(conversationId: conversationId))
////
////    return controller
//  }
  
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
