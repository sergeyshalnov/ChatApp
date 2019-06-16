//
//  PixabayImagesParser.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 22/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation


class PixabayParser {
  typealias Model = [PixabayImageModel]
  
}


// MARK: IParser extension 

extension PixabayParser: IParser {
  
  func parse(data: Data) -> [PixabayImageModel]? {
    do {
      let pixabay = try JSONDecoder().decode(PixabayRequestModel.self, from: data)
      return pixabay.hits
    } catch {
      return nil
    }
  }
  
}
