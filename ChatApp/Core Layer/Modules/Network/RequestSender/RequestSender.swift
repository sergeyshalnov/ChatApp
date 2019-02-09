//
//  RequestSender.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 22/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation


class RequestSender: IRequestSender {
    
    private let session = URLSession.shared
    
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
            guard let data = data,
                  let parsedModel: Parser.Model = requestConfig.parser.parse(data: data) else {
                    completion(nil)
                    return
            }
            
            completion(parsedModel)
        }
        
        task.resume()
    }
    
    
}
