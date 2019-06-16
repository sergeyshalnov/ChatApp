//
//  PixabayImagesRequest.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 22/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation


class PixabayRequest {
  
  // MARK: - Private variables
  
  private var baseUrl: String = "https://pixabay.com/api/"
  private var question: String
  private let apiKey: String
  
  // MARK: - Private computed variables
  
  private var parameters: [String: String] {
    return [
      "key": apiKey,
      "q": question.replacingOccurrences(of: " ", with: "+"),
      "per_page": "200"
    ]
  }
  
  private var url: String {
    let params = parameters.map { "\($0.key)=\($0.value)" }
    return baseUrl + "?" + params.joined(separator: "&")
  }
  
  
  // MARK: - Initialization
  
  init(apiKey: String, question: String = "") {
    self.apiKey = apiKey
    self.question = question
  }
  
}


// MARK: - IRequest extension

extension PixabayRequest: IRequest {
  
  var urlRequest: URLRequest? {
    if let url = URL(string: url) {
      return URLRequest(url: url)
    }
    return nil
  }
  
}
