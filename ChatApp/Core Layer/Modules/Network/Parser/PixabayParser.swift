//
//  PixabayImagesParser.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 22/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation

final class PixabayParser: IParser {
  typealias Model = [PixabayImageModel]
  
  func parse(data: Data) -> [PixabayImageModel]? {
    do {
      let pixabay = try JSONDecoder().decode(PixabayRequestModel.self, from: data)
      return pixabay.hits
    } catch {
      return nil
    }
  }
  
}

