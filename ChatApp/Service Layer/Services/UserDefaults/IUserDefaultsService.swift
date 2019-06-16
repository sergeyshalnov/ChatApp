//
//  IUserDefaultsService.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/06/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation


protocol IUserDefaultsService {
  
  func set(value: String, for key: UserDefaultsService.Key)
  func get(for key: UserDefaultsService.Key) -> String?
  func remove(for key: UserDefaultsService.Key)
  
}
