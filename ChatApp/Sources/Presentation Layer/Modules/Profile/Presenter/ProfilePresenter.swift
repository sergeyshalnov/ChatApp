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
      let title = isSuccess ? String.accountSuccessSaveTitleWord : nil
      let message = isSuccess ? String.accountSuccessSaveWord : String.accountFailureSaveWord
      let action = UIAlertAction(title: String.okWord, style: .default, handler: nil)
      
      DispatchQueue.main.async {
        if isSuccess {
          self?.output?.saveSuccess()
        }
        
        self?.output?.display(title: title, message: message, with: [action])
      }
    }
  }
  
}

// MARK: - Private String

private extension String {
  
  static let accountSuccessSaveTitleWord = "ACCOUNT_SUCCESS_SAVE_TITLE_WORD".localized()
  static let accountSuccessSaveWord = "ACCOUNT_SUCCESS_SAVE_WORD".localized()
  static let accountFailureSaveWord = "ACCOUNT_FAILURE_SAVE_WORD".localized()
  static let okWord = "OK_WORD".localized()
  
}
