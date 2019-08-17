//
//  CATextField.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 13/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit.UITextField

class CATextField: UITextField {
  
  // MARK: - Variables
  
  var padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
  
  // MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: - Lifecycle
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    DispatchQueue.main.async { [weak self] in
      guard let self = self else {
        return
      }
      
      self.cornerRadius(self.padding.left)
    }
  }
  
  // MARK: - Overriden
  
  override open func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override open func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
}

// MARK: - Setup

extension CATextField {
  
  private func setup() {
    backgroundColor = UIColor.Palette.Grey.textField
  }
  
}
