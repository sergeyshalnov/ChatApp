//
//  RequestFactory+Pixabay.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/06/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation


// MARK: - Pixabay extension

extension RequestFactory {
  
  struct Pixabay {
    private static let apiKey = "10776337-be1cf7658140f707862dbc3ee"
    
    static func images(question: String = "") -> RequestConfig<PixabayParser> {
      let request = PixabayRequest(apiKey: apiKey, question: question)
      return RequestConfig<PixabayParser>(request: request, parser: PixabayParser())
    }
  }
  
}
