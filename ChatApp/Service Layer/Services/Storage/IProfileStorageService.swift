//
//  IProfileStorageService.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/06/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation


protocol IProfileStorageService {
  
  func load(completion: @escaping (ProfileData?)->())
  func save(profile: ProfileData, completion: @escaping (Bool) -> Void)
  
}
