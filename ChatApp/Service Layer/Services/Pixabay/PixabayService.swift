//
//  PixabayService.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 23/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit

final class PixabayService {
  
  // MARK: - Variables
  
  private let requestSender: IRequestSender
  private let requestLoader: IRequestLoader
  private var images: [PixabayImageModel]?
  
  // MARK: - Init
  
  init(requestSender: IRequestSender, requestLoader: IRequestLoader) {
    self.requestSender = requestSender
    self.requestLoader = requestLoader
  }
  
}

// MARK: - IImageManager

extension PixabayService: IImageManager {
  
  func performRequest(completion: @escaping (Int) -> Void) {
    let requestConfig = RequestFactory.Pixabay.images()
    
    requestSender.send(requestConfig: requestConfig) { images in
      self.images = images
      
      if let count = images?.count {
        completion(count)
      } else {
        completion(0)
      }
    }
  }
  
  func webFormat(index: Int) -> String? {
    guard let imageURL = images?[index].webformatURL else {
      return nil
    }
    
    return imageURL
  }
  
  func load(url: String, completion: @escaping (UIImage?) -> Void) {
    requestLoader.load(url: url) { (data) in
      guard
        let data = data,
        let image = UIImage(data: data)
        else {
          completion(nil)
          return
      }
      
      completion(image)
    }
  }
  
}
