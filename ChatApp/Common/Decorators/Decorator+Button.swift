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
      
      // MARK: - Decorable
      
      func decorate(view: UIButton) {
        view.setTitleColor(.white, for: .normal)
        
        view.contentHorizontalAlignment = .center
        view.backgroundColor = .black
        view.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        view.xibLocalizableKey = "SEND_WORD".localized()
      }
      
    }
    
  }
  
}
