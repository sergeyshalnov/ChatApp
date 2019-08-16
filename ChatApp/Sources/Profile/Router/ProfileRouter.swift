//
//  ProfileRouter.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import Foundation

final class ProfileRouter {
  
  weak var view: ProfileViewController?
  
  // MARK: - Init
  
  init(view: ProfileViewController) {
    self.view = view
  }
  
}

// MARK: - IProfileRouter

extension ProfileRouter: IProfileRouter {
  
}
