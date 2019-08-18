//
//  OnboardingView.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 04/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import UIKit

final class OnboardingView: UIView {
  
  // MARK: - Outlets
  
  @IBOutlet private weak var signInButton: UIButton!
  
  // MARK: - Variables
  
  var isEnableSignInButton: Bool {
    get {
      return signInButton.isEnabled
    }
    set {
      signInButton.isEnabled = newValue
    }
  }
  
  // MARK: - Lifecycle
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    signInButton.decorate(with: Decorator.Button.Regular())
    
    DispatchQueue.main.async { [weak self] in
      self?.signInButton.cornerRadius(10)
    }
  }
  
}
