//
//  ProfilePresenter.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import UIKit

final class ProfilePresenter {
  
  // MARK: - Variables
  
  private weak var output: IProfilePresenterOutput?
  private let profileStorageService: IProfileStorageService
  
  // MARK: - Init
  
  init(output: IProfilePresenterOutput, profileStorageService: IProfileStorageService) {
    self.output = output
    self.profileStorageService = profileStorageService
  }
  
}

// MARK: - IProfilePresenterInput

extension ProfilePresenter: IProfilePresenterInput {
  
  func load() {
    profileStorageService.load { [weak self] (profile) in
      guard let profile = profile else {
        return
      }
      
      DispatchQueue.main.async {
        self?.output?.display(profile: profile)
      }
    }
  }
  
  func save(profile: ProfileData) {
    profileStorageService.save(profile: profile) { [weak self] (isSuccess) in
      let title = isSuccess ? "ACCOUNT_SUCCESS_SAVE_TITLE_WORD".localized(): nil
      let message = isSuccess ? "ACCOUNT_SUCCESS_SAVE_WORD".localized() : "ACCOUNT_FAILURE_SAVE_WORD".localized()
      let action = UIAlertAction(title: "OK_WORD".localized(), style: .default, handler: nil)
      
      DispatchQueue.main.async {
        if isSuccess {
          self?.output?.saveSuccess()
        }
        
        self?.output?.display(title: title, message: message, with: [action])
      }
    }
  }
  
}
