//
//  Extension.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 07/10/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit

// MARK: - Add new colors

extension UIColor {
    static var online: UIColor {
        get {
            return UIColor(red:0.99, green:0.96, blue:0.84, alpha:1.0)
        }
    }
    static var greyBubble: UIColor {
        get {
            return UIColor(red:0.90, green:0.90, blue:0.92, alpha:1.0)
        }
    }
    static var blueBubble: UIColor {
        get {
            return UIColor(red:0.19, green:0.62, blue:0.99, alpha:1.0)
        }
    }
    
    static var greenPantone: UIColor {
        get {
            return UIColor(red:0.00, green:0.73, blue:0.19, alpha:1.0)
        }
    }
}
