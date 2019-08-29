//
//  IProfileRouter.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import UIKit.UIImagePickerController

protocol IProfileRouter {
  
  func open(sourceType: UIImagePickerController.SourceType,
            presentationStyle: UIModalPresentationStyle,
            animated: Bool)
  
  func close(animated: Bool)
  func navigateToPixabay(animated: Bool)
  
}
