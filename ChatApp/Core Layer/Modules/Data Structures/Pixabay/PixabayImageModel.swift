//
//  PixabayImage.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/06/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation


struct PixabayImageModel: Codable {
  
  let id: Int?
  let previewURL: String?
  let webformatURL: String?
  let largeImageURL: String?
  let fullHDURLL: String?
  let imageURL: String?
  
}
