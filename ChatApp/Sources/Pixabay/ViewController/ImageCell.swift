//
//  ImageCell.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 22/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {

  // MARK: - Identifier
  
  static let identifier = String(describing: ImageCell.self)
  
  // MARK: - Variables

  private(set) lazy var imageView: CAImageView = makeImageView()
  
  // MARK: - awakeFromNib
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
}

// MARK: - Setup

private extension ImageCell {
  
  func setup() {
    addSubview(imageView)
  }
  
}

// MARK: - Makers

private extension ImageCell {
  
  func makeImageView() -> CAImageView {
    let imageView = CAImageView()
    
    imageView.image = UIImage(named: "ImagePlaceholder")
    imageView.contentMode = .scaleAspectFill
    
    return imageView
  }
  
}
