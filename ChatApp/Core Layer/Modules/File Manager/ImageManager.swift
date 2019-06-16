//
//  ImageManager.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 15/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit



protocol IImageLoader {
  
  func load(filename: String) -> UIImage?
  
}

protocol IImageSaver {
  
  func save(image: UIImage, filename: String) -> Bool
  
}

class ImageManager: IImageLoader {
  
  func load(filename: String) -> UIImage? {
    let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let url = dir.appendingPathComponent(filename)
    
    do {
      let data = try Data(contentsOf: url)
      return UIImage(data: data)
    } catch { return nil }
  }
  
}

extension ImageManager: IImageSaver {
  
  func save(image: UIImage, filename: String) -> Bool {
    let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let url = dir.appendingPathComponent(filename)
    
    if let data = image.pngData() {
      do {
        try data.write(to: url)
      } catch { return false }
    } else {
      return false
    }
    
    return true
  }
  
}
