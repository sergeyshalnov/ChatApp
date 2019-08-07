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
  
  @IBOutlet private weak var containerView: UIView!
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
    
    containerView.backgroundColor = .init(hex: "#f2f2f2")
    containerView.cornerRadius(16)
  }
  
}
