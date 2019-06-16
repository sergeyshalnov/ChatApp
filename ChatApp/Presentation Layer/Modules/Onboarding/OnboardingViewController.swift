//
//  OnboardingViewController.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/06/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
  
  // MARK: - Private variables
  
  private var username: String?
  
  // MARK: - Services
  
  let presentationAssembly: IPresentationAssembly
  let userDefaultsService: IUserDefaultsService
  let profileStorageService: IProfileStorageService
  
  
  // MARK: - Initialization
  
  init(
    presentationAssembly: IPresentationAssembly,
    userDefaultsService: IUserDefaultsService,
    profileStorageService: IProfileStorageService
  ) {
    self.presentationAssembly = presentationAssembly
    self.userDefaultsService = userDefaultsService
    self.profileStorageService = profileStorageService
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
}


// MARK: - Actions extension

extension OnboardingViewController {
  
  @IBAction func signInButtonTouch(_ sender: Any) {
    guard let username = username else {
      #if DEBUG
        print("Username Text Field is empty!")
      #endif
      
      return
    }
    
    userDefaultsService.set(value: username, for: .username)
    
    profileStorageService.save(profile: ProfileData(
      username: username,
      information: nil,
      image: UIImage(named: "profileImage"))) { (isSuccess) in
        #if DEBUG
          print("Save profile on onboarding - isSucces? - : \(isSuccess)")
        #endif
    }
    
    present(presentationAssembly.conversationsListViewController(), animated: true)
  }
  
  @IBAction func usernameTextFieldChanged(_ sender: Any) {
    guard let textField = sender as? UITextField else {
      return
    }
    
    username = textField.text
  }
  
}
