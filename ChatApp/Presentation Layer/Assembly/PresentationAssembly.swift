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
    
    func editProfileViewController() -> EditProfileViewController
    
    func imagesViewController(imageDelegate: ImageDelegate) -> ImagesViewController 
    
}

class PresentationAssembly: IPresentationAssembly {
    
    private let serviceAssembly: IServiceAssembly
    
    init(serviceAssembly: IServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func conversationsListViewController() -> UINavigationController {
        let storyboard = UIStoryboard(name: "ConversationsListViewController", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NavigationController")
        
        guard let navigator = controller as? UINavigationController else { fatalError() }
        guard let vc = navigator.viewControllers.first as? ConversationsListViewController else { fatalError() }
        
        let coreData: ICoreDataManager = CoreDataManager()
        
        vc.setupAssembly(presentationAssembly: self,
                         communicationService: serviceAssembly.communicationService(username: "Sergey Shalnov"),
                         communicationStorageService: serviceAssembly.communicationStorageService(),
                         profileStorageService: serviceAssembly.profileStorageService(),
                         conversationFetchResultsController: coreData.conversationFetchResultsController())
        
        return navigator
    }
    
    func conversationViewController(title: String?, conversationId: String, conversationListDelegate: ConversationListDelegate) -> ConversationViewController {
        let controller = UIStoryboard(name: "ConversationViewController", bundle:nil).instantiateInitialViewController()
        guard let conversation = controller as? ConversationViewController else { fatalError() }
        
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 44))
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.greenPantone
        label.textAlignment = .center
        
        conversation.navigationItem.titleView = label
        
        conversation.conversationId = conversationId
        conversation.conversationListDelegate = conversationListDelegate
        
        let coreData: ICoreDataManager = CoreDataManager()
        
        conversation.setupAssembly(presentationAssembly: self,
                                   communicationStorageService: serviceAssembly.communicationStorageService(),
                                   messageFetchResultsController: coreData.messageFetchResultsController(conversationId: conversationId))
        
        return conversation
    }
    
    func profileViewController() -> ProfileViewController {
        let storyboard = UIStoryboard(name: "ProfileViewController", bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() as? ProfileViewController else { fatalError() }
        
        controller.setupAssembly(presentationAssembly: self,
                                 profileStorageService: serviceAssembly.profileStorageService())
        
        return controller
    }
    
    func editProfileViewController() -> EditProfileViewController {
        let storyboard = UIStoryboard(name: "EditProfileViewController", bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() as? EditProfileViewController else { fatalError() }
        
        controller.setupAssembly(presentationAssembly: self,
                                 profileStorageService: serviceAssembly.profileStorageService())
        
        return controller
    }
    
    func imagesViewController(imageDelegate: ImageDelegate) -> ImagesViewController {
        let storyboard = UIStoryboard(name: "ImagesViewController", bundle:nil)
        guard let controller = storyboard.instantiateInitialViewController() as? ImagesViewController else { fatalError() }
        
        controller.setupAssembly(presentationAssembly: self,
                                 pixabayService: serviceAssembly.pixabayService(),
                                 imageDelegate: imageDelegate)
        
        return controller
    }

}
