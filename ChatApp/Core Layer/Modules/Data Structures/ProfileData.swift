//
//  ProfileData.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 15/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit


struct ProfileData {
  
  let username: String?
  let information: String?
  let image: UIImage?
  
  init(username: String? = nil, information: String? = nil, image: UIImage? = nil) {
    self.username = username
    self.information = information
    self.image = image
  }
  
}
