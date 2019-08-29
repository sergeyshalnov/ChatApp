//
//  DataParser.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 15/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation

final class DataParser<Model: Codable>: IParser {
  
  func parse(data: Data) -> Model? {
    return try? JSONDecoder().decode(Model.self, from: data)
  }
  
}
