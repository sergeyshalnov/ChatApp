//
//  PixabayImagesRequest.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 22/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation


class PixabayImagesRequest: IRequest {
    
    private var baseUrl: String = "https://pixabay.com/api/"
    private var question: String
    private let apiKey: String
    
    private var getParameters: [String: String] {
        return ["key": apiKey,
                "q": question.replacingOccurrences(of: " ", with: "+"),
                "per_page": "200"]
    }
    
    private var url: String {
        let parameters = getParameters.map({ "\($0.key)=\($0.value)"}).joined(separator: "&")
        return baseUrl + "?" + parameters
    }
    
    var urlRequest: URLRequest? {
        if let url = URL(string: url) {
            return URLRequest(url: url)
        }
        return nil
    }
    
    init(apiKey: String, question: String = "") {
        self.apiKey = apiKey
        self.question = question
    }
    
}
