//
//  OnboardingView.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/06/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit


class OnboardingView: UIView {
  
  // MARK: - Outlets
  
  @IBOutlet weak var usernameTextField: UITextField!
  
  
  // MARK: - Main
  
  override func awakeFromNib() {
    setup()
  }
  
}


// MARK: - Setup extension 

extension OnboardingView {
  
  private func setup() {
    
  }
  
}
