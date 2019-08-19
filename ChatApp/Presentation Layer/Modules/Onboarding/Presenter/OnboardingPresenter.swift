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
  private let profileStorageService: IProfileStorageService
  
  // MARK: - Init
  
  init(output: IOnboardingPresenterOutput,
       profileStorageService: IProfileStorageService) {
    
    self.output = output
    self.profileStorageService = profileStorageService
  }
  
}

// MARK: - IOnboardingPresenterInput

extension OnboardingPresenter: IOnboardingPresenterInput {
  
  func save(username: String) {
    let profile = ProfileData(username: username, information: nil, image: nil)
    
    profileStorageService.save(profile: profile) { [weak self] (isSuccess) in
      DispatchQueue.main.async {
        self?.output?.saveResult(isSuccess: isSuccess)
      }
    }
  }
  
}
