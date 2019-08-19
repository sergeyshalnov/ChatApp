//
//  UIView+Extensions.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 04/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit.UIView

extension UIView {
  
  func cornerRadius(_ value: CGFloat, for corners: UIRectCorner = .allCorners) {
    let maskLayer = CAShapeLayer()
    let cornerRadii = CGSize(width: value, height: value)
    let bezierPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
    
    maskLayer.path = bezierPath.cgPath
    layer.mask = maskLayer
  }
  
  func addSubview(_ view: UIView, insets: UIEdgeInsets) {
    addSubview(view)
    
    view.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
      view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: insets.top),
      view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
      view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom)
      ])
  }
  
}
