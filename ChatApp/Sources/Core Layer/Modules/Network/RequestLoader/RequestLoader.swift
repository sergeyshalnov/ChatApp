//
//  RequestLoader.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 23/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation

final class RequestLoader {
  
  // MARK: - Variables
  
  private let session = URLSession.shared
  private var task: URLSessionDataTask?
  
}

// MARK: - IRequestLoader

extension RequestLoader: IRequestLoader {
  
  func load(url: String, completion: @escaping (Data?) -> Void) {
    task?.cancel()
    
    guard let url = URL(string: url) else {
      completion(nil)
      return
    }
    
    task = session.dataTask(with: url) { (data, _, error) in
      if error == nil {
        completion(data)
      } else {
        completion(nil)
      }
    }
    
    task?.resume()
  }
  
  func cancel() {
    task?.cancel()
  }
  
}


