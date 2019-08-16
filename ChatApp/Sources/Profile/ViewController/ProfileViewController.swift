//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import UIKit

final class ProfileViewController: UIViewController {
  
  // MARK: - Variables
  
  var output: IProfileViewOutput?
  var router: IProfileRouter?
  
  // MARK: - Init
  
  init(configurator: IProfileConfigurator = ProfileConfigurator()) {
    super.init(nibName: nil, bundle: nil)
    
    configure(configurator: configurator)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  // MARK: - Configure
  
  private func configure(configurator: IProfileConfigurator) {
    configurator.configure(view: self)
  }
  
}

// MARK: - IProfileViewInput

extension ProfileViewController: IProfileViewInput {
  
}
