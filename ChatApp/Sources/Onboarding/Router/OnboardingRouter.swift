//
//  OnboardingRouter.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 04/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import Foundation

final class OnboardingRouter {
  
  // MARK: - Private variables
  
  private weak var view: OnboardingViewController?
  
  // MARK: - Init
  
  init(view: OnboardingViewController) {
    self.view = view
  }
  
}

// MARK: - IOnboardingRouter

extension OnboardingRouter: IOnboardingRouter {
  
  func close(animated: Bool) {
    view?.dismiss(animated: animated, completion: nil)
  }
  
}
