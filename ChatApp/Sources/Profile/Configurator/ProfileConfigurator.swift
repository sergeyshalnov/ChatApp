//
//  ProfileConfigurator.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import Foundation

final class ProfileConfigurator: IProfileConfigurator {
  
  func configure(view: ProfileViewController) {
    let router = ProfileRouter(view: view)
    let presenter = ProfilePresenter(output: view)
    
    view.output = presenter
    view.router = router
  }
  
}
