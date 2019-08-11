//
//  OnboardingPresenter.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 04/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import UIKit

final class OnboardingPresenter {
  
  // MARK: - Variables
  
  private weak var output: IOnboardingPresenterOutput?
  
  // TODO: - Remove UserDefaults service
  private let userDefaultsService: IUserDefaultsService
  private let profileStorageService: IProfileStorageService
  
  // MARK: - Init
  
  init(output: IOnboardingPresenterOutput,
       userDefaultsService: IUserDefaultsService,
       profileStorageService: IProfileStorageService) {
    
    self.output = output
    self.userDefaultsService = userDefaultsService
    self.profileStorageService = profileStorageService
  }
  
}

// MARK: - IOnboardingPresenterInput

extension OnboardingPresenter: IOnboardingPresenterInput {
  
  func save(username: String) {
    let profile = ProfileData(username: username,
                              information: nil,
                              image: UIImage(named: "profileImage"))
    
    userDefaultsService.set(value: username, for: .username)
    profileStorageService.save(profile: profile) { [weak self] (isSuccess) in
      DispatchQueue.main.async {
        self?.output?.saveResult(isSuccess: isSuccess)
      }
    }
  }
  
}
