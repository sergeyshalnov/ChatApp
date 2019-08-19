//
//  ProfileStorageService.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 17/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation

final class ProfileStorageService {
  
  // MARK: - Variables
  
  private var coreDataStorageManager: IProfileStorage
  
  // MARK: - Init
  
  init(coreDataStorageManager: IProfileStorage) {
    self.coreDataStorageManager = coreDataStorageManager
  }
  
}

// MARK: - IProfileStorageService

extension ProfileStorageService: IProfileStorageService {
  
  func load(completion: @escaping (ProfileData?)->()) {
    coreDataStorageManager.load(completion: completion)
  }
  
  func save(profile: ProfileData, completion: @escaping (Bool) -> Void) {
    coreDataStorageManager.save(profile: profile, completion: completion)
  }
  
}
