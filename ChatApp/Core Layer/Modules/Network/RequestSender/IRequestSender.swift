//
//  IRequestSender.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 22/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation

struct RequestConfig<Parser> where Parser: IParser {
    let request: IRequest
    let parser: Parser
}

protocol IRequestSender {
    
    func send<Parser>(requestConfig: RequestConfig<Parser>,
                      completion: @escaping (Parser.Model?) -> Void)
    
}
