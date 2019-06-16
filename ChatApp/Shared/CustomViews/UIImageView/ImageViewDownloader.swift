//
//  CustomImageView.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 23/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit


class ImageViewDownloader: UIImageView {
  
  // MARK: - Private services
  
  private lazy var loaderService: IRequestLoader = RequestLoader()
  
  // MARK: - Private variables
  
  private var url: String?
  
}


// MARK: - Pixabay extension

extension ImageViewDownloader {
  
  func pixabayLoader(url: String) {
    self.url = url
    
    image = UIImage(named: "ImagePlaceholder")
    
    loaderService.load(url: url) { (data) in
      guard let data = data else {
        return
      }
      
      DispatchQueue.main.async { [weak self] in
        if self?.url == url {
          self?.image = UIImage(data: data)
        }
      }
    }
  }
  
}
