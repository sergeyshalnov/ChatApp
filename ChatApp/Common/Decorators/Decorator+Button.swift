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
    
    struct Regular: Decorable {
      typealias View = UIButton
      
      // MARK: - Decorable
      
      func decorate(view: UIButton) {
        view.backgroundColor = .clear
        
        view.setTitleColor(.white, for: .normal)
        view.setTitleColor(UIColor.Palette.Grey.placeholder, for: .disabled)
        
        view.contentHorizontalAlignment = .center
        view.setBackgroundImage(UIImage(color: .black), for: .normal)
        view.setBackgroundImage(UIImage(color: UIColor.Palette.Grey.textField), for: .disabled)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
      }
      
    }
    
  }
  
}
