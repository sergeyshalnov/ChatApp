//
//  Decorator+Button.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 17/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit.UIButton

extension Decorator {
  
  struct Button {
    
    struct Send: Decorable {
      typealias View = UIButton
      
      // MARK: - Variables
      
      private let tintColor: UIColor
      
      // MARK: - Init
      init(tintColor: UIColor) {
        self.tintColor = tintColor
      }
      
      // MARK: - Decorable
      
      func decorate(view: UIButton) {
        view.contentHorizontalAlignment = .center
        
        view.setTitleColor(tintColor, for: .normal)
        view.xibLocalizableKey = "SEND_WORD".localized()
        view.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
      }
      
    }
    
  }
  
}
