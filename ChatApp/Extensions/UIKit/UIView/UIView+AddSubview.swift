//
//  UIView+AddSubview.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 07/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit.UIView

extension UIView {
  
  func addSubview(_ view: UIView, insets: UIEdgeInsets) {
    let constraints = [view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
                       view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: insets.top),
                       view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
                       view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom)]
    
    addSubview(view)
    view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(constraints)
  }
  
}
