//
//  ProfileRouter.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import UIKit.UIImagePickerController

final class ProfileRouter {
  
  // MARK: - Variables
  
  private var presentationAssembly: IPresentationAssembly
  weak var view: ProfileViewController?
  
  // MARK: - Init
  
  init(view: ProfileViewController, presentationAssembly: IPresentationAssembly) {
    self.view = view
    self.presentationAssembly = presentationAssembly
  }
  
}

// MARK: - IProfileRouter

extension ProfileRouter: IProfileRouter {
  
  func open(sourceType: UIImagePickerController.SourceType, presentationStyle: UIModalPresentationStyle, animated: Bool) {
    if UIImagePickerController.isSourceTypeAvailable(sourceType) {
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = view
      imagePicker.sourceType = sourceType
      imagePicker.allowsEditing = true
      imagePicker.modalPresentationStyle = presentationStyle
      
      view?.present(imagePicker, animated: animated, completion: nil)
    }
  }
  
  func close(animated: Bool) {
    view?.dismiss(animated: animated, completion: nil)
  }
  
  func navigateToPixabay(animated: Bool) {
    let controller = presentationAssembly.pixabay(for: view)
    controller.modalPresentationStyle = .fullScreen
    view?.present(controller, animated: animated)
  }
  
}
