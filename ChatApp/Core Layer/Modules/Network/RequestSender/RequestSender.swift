//
//  RequestSender.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 22/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation


class RequestSender {
  
  private let session = URLSession.shared
  
}


// MARK: - IRequestSender extension

extension RequestSender: IRequestSender {
  
  func send<Parser>(requestConfig: RequestConfig<Parser>, completion: @escaping (Parser.Model?) -> Void) where Parser : IParser {
    guard let urlRequest = requestConfig.request.urlRequest else {
      completion(nil)
      return
    }
    
    let task = session.dataTask(with: urlRequest) { (data, _, error) in
      if let error = error {
        print("Error in RequestSender: \(error.localizedDescription)")
        completion(nil)
      }
      
      guard
        let data = data,
        let model = requestConfig.parser.parse(data: data)
        else {
          completion(nil)
          return
      }
      
      completion(model)
    }
    
    task.resume()
  }
  
}
