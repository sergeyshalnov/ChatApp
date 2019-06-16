//
//  ProfileStorageService.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 17/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation


class ProfileStorageService {
  
  // MARK: - Private variables
  
  private var coreDataStorageManager: IProfileStorage
  
  
  // MARK: - Initialization
  
  init(coreDataStorageManager: IProfileStorage) {
    self.coreDataStorageManager = coreDataStorageManager
  }
  
}


// MARK: - IProfileStorageService extension 

extension ProfileStorageService: IProfileStorageService {
  
  func load(completion: @escaping (ProfileData?)->()) {
    coreDataStorageManager.load(completion: completion)
  }
  
  func save(profile: ProfileData, completion: @escaping (Bool) -> Void) {
    coreDataStorageManager.save(profile: profile, completion: completion)
  }
  
}
