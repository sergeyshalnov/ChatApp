//
//  PixabayRouter.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 18/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import Foundation

final class PixabayRouter {
  
  weak var view: PixabayViewController?
  
  // MARK: - Init
  
  init(view: PixabayViewController) {
    self.view = view
  }
  
}

// MARK: - IPixabayRouter

extension PixabayRouter: IPixabayRouter {
  
  func close(animated: Bool) {
    view?.dismiss(animated: animated, completion: nil)
  }
  
}
