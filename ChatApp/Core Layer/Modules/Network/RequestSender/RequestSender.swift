//
//  RequestSender.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 22/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation

final class RequestSender {
  
  // MARK: - Variables
  
  private let session = URLSession.shared
  
}

// MARK: - IRequestSender

extension RequestSender: IRequestSender {
  
  func send<Parser>(requestConfig: RequestConfig<Parser>,
                    completion: @escaping (Parser.Model?) -> Void) where Parser : IParser {
    
    guard let urlRequest = requestConfig.request.urlRequest else {
      completion(nil)
      return
    }
    
    let task = session.dataTask(with: urlRequest) { (data, _, error) in
      if let error = error {
        #if DEBUG
        print("Error in RequestSender: \(error.localizedDescription)")
        #endif
        
        completion(nil)
      }
      
      guard let data = data else {
        completion(nil)
        return
      }
      
      completion(requestConfig.parser.parse(data: data))
    }
    
    task.resume()
  }
  
}
