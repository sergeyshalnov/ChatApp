//
//  UserDefaultsService.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/06/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation


class UserDefaultsService {
  
  enum Key: String {
    case username
    
    var value: String {
      return self.rawValue
    }
  }
  
}


// MARK: - IUserDefaultsService extension 

extension UserDefaultsService: IUserDefaultsService {

  func set(value: String, for key: UserDefaultsService.Key) {
    UserDefaults.standard.set(value, forKey: key.value)
  }
  
  func get(for key: UserDefaultsService.Key) -> String? {
    return UserDefaults.standard.object(forKey: key.value) as? String
  }
  
  func remove(for key: UserDefaultsService.Key) {
    UserDefaults.standard.removeObject(forKey: key.value)
  }
  
}
