//
//  RequestFactory.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 23/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation

struct RequestFactory {
    
    struct Pixabay {
        private static let apiKey = "10776337-be1cf7658140f707862dbc3ee"
        
        static func images(question: String = "") -> RequestConfig<PixabayImagesParser> {
            let request = PixabayImagesRequest(apiKey: apiKey, question: question)
            return RequestConfig<PixabayImagesParser>(request: request, parser: PixabayImagesParser())
        }
    }
    
}
