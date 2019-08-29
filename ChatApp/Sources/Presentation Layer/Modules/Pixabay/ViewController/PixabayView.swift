//
//  PixabayView.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 18/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import UIKit

final class PixabayView: UIView {
  
  // MARK: - Outlets
  
  @IBOutlet private(set) weak var imagesCollectionView: UICollectionView!
  @IBOutlet private(set) weak var activityIndicator: UIActivityIndicatorView!
  
}

// MARK: - Setup

extension PixabayView {
  
  func setup() {
    let nib = UINib(nibName: ImageCell.identifier, bundle: nil)
    imagesCollectionView.register(nib, forCellWithReuseIdentifier: ImageCell.identifier)
  }
  
}
