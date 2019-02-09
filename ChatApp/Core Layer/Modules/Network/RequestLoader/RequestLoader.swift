//
//  RequestLoader.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 23/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation


class RequestLoader: NSObject, IRequestLoader {
    
    private let session = URLSession.shared
    private var task: URLSessionDataTask?

    func load(url: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }
        
        task = session.dataTask(with: url) { (data, _, error) in
            completion(error != nil ? nil : data)
        }

        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
    
}


