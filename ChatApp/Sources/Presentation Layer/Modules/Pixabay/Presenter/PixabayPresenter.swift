//
//  PixabayPresenter.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 18/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import UIKit.UICollectionView

final class PixabayPresenter: NSObject {
  
  // MARK: - Variables
  
  private weak var output: IPixabayPresenterOutput?
  private let pixabayService: IImageManager
  
  private var count = 0
  
  // MARK: - Init
  
  init(output: IPixabayPresenterOutput, imageManager pixabayService: IImageManager) {
    self.output = output
    self.pixabayService = pixabayService
  }
  
}

// MARK: - IPixabayPresenterInput

extension PixabayPresenter: IPixabayPresenterInput {
  
  func performRequest() {
    pixabayService.performRequest { [weak self] (count) in
      DispatchQueue.main.async {
        self?.count = count
        self?.output?.updateView()
      }
    }
  }
  
}

// MARK: - UICollectionViewDataSource

extension PixabayPresenter: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    
    return count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell
      else {
        return UICollectionViewCell()
    }
    
    cell.imageView.frame = cell.bounds
    
    if let url = pixabayService.webFormat(index: indexPath.row) {
      cell.imageView.load(url: url)
    }
    

    return cell
  }
  
}

// MARK: - UICollectionViewDelegate

extension PixabayPresenter: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard
      let url = pixabayService.webFormat(index: indexPath.row)
      else {
        return
    }
    
    pixabayService.load(url: url) { [weak self] (image) in
      DispatchQueue.main.async {
        self?.output?.display(image: image)
      }
    }
    
  }
  
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PixabayPresenter: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.bounds.width
    let cellWidth = width / 3
    
    return CGSize(width: cellWidth, height: cellWidth)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
}
