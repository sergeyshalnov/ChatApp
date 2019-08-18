//
//  ProfileRouter.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import UIKit.UIImagePickerController

final class ProfileRouter {
  
  weak var view: ProfileViewController?
  
  // MARK: - Init
  
  init(view: ProfileViewController) {
    self.view = view
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
    } else {
//      let alert = Alert.controller(type: .cameraError)
//      view?.present(alert, animated: animated, completion: nil)
    }
  }
  
}
