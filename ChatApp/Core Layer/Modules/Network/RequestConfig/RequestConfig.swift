//
//  RequestConfig.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/06/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation


struct RequestConfig<Parser> where Parser: IParser {
  
  let request: IRequest
  let parser: Parser
  
}
