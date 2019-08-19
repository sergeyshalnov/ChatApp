//
//  IProfileStorage.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 11/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation

protocol IProfileStorage {
  
  func load(completion: @escaping (ProfileData?) -> Void)
  func save(profile: ProfileData, completion: @escaping (Bool) -> Void)
  
}
