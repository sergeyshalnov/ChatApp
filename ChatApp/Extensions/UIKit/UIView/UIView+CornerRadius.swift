//
//  UIView+CornerRadius.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 04/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit

extension UIView {
  
  func cornerRadius(_ value: CGFloat, for corners: UIRectCorner = .allCorners) {
    let maskLayer = CAShapeLayer()
    let cornerRadii = CGSize(width: value, height: value)
    let bezierPath = UIBezierPath(roundedRect: bounds,
                                  byRoundingCorners: corners,
                                  cornerRadii: cornerRadii)
    
    maskLayer.path = bezierPath.cgPath
    layer.mask = maskLayer
  }
  
}
