//
//  ProfileStorageService.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 17/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation

protocol IProfileStorageService {
  
  func load(completion: @escaping (ProfileData?)->())
  func save(profile: ProfileData, completion: @escaping (Bool) -> Void)
  
}

class ProfileStorageService: IProfileStorageService {
  
  private var coreDataStorageManager: IProfileStorage
  
  init(coreDataStorageManager: IProfileStorage) {
    self.coreDataStorageManager = coreDataStorageManager
  }
  
  func load(completion: @escaping (ProfileData?)->()) {
    coreDataStorageManager.load(completion: completion)
  }
  
  func save(profile: ProfileData, completion: @escaping (Bool) -> Void) {
    coreDataStorageManager.save(profile: profile, completion: completion)
  }
  
}
