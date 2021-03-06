//
//  IProfileViewOutput.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import Foundation

protocol IProfileViewOutput {
  
  func load() 
  func save(profile: ProfileData)
  
}
