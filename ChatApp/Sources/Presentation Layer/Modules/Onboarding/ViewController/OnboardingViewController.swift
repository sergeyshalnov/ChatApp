//
//  OnboardingViewController.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 04/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import UIKit

final class OnboardingViewController: UIViewController, CustomViewController {
  typealias RootView = OnboardingView
  
  // MARK: - Variables
  
  var output: IOnboardingViewOutput?
  var router: IOnboardingRouter?
  
  private var username: String?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = String.onboardingTitleWord
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
}

// MARK: - IBActions

private extension OnboardingViewController {
  
  @IBAction func signInButtonTouch(_ sender: Any) {
    guard let username = username else {
      return
    }
    
    output?.save(username: username)
  }
  
  @IBAction func usernameTextFieldEditingChanged(_ sender: UITextField) {
    username = sender.text
    view().isEnableSignInButton = !(sender.text?.isEmpty ?? true)
  }
  
}

// MARK: - IOnboardingViewInput

extension OnboardingViewController: IOnboardingViewInput {
  
  func saveResult(isSuccess: Bool) {
    if isSuccess {
      router?.close(animated: true)
    } else {
      let action = UIAlertAction(title: String.okWord, style: .default, handler: nil)
      alert(title: String.errorWord, message: String.saveErrorWord, actions: [action])
    }
  }
  
}

// MARK: - Private String

private extension String {
  
  static let onboardingTitleWord = "ONBOARDING_TITLE_WORD".localized()
  static let okWord = "OK_WORD".localized()
  static let errorWord = "ERROR_WORD".localized()
  static let saveErrorWord = "SAVE_ERROR_WORD".localized()
  
}
