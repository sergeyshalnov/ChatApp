//
//  ProfilePresenter.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import Foundation

final class ProfilePresenter {
  
  private weak var output: IProfilePresenterOutput?
  
  init(output: IProfilePresenterOutput) {
    self.output = output
  }
  
}

// MARK: - IProfilePresenterInput

extension ProfilePresenter: IProfilePresenterInput {
  
}
