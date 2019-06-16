//
//  ImagesViewController.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 22/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController {
  
  // MARK: - Outlets
  
  @IBOutlet weak var imagesCollectionView: UICollectionView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  
  // MARK: - Variables
  
  private var cellsCount: Int = 0 {
    didSet {
      imagesCollectionView.reloadData()
    }
  }
  
  // MARK: Assembly variables
  
  private var presentationAssembly: IPresentationAssembly
  private var pixabayService: IImageManager
  private var imageDelegate: ImageDelegate
  
  
  // MARK: - Init
  
  init(presentationAssembly: IPresentationAssembly, pixabayService: IImageManager, imageDelegate: ImageDelegate) {
    self.presentationAssembly = presentationAssembly
    self.pixabayService = pixabayService
    self.imageDelegate = imageDelegate
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  
  // MARK: - ViewController Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
  }
  
  
  // MARK: - Setup Assembly
  
  func setupAssembly(presentationAssembly: IPresentationAssembly, pixabayService: IImageManager, imageDelegate: ImageDelegate) {
    self.presentationAssembly = presentationAssembly
    self.pixabayService = pixabayService
    self.imageDelegate = imageDelegate
  }
  
  // MARK: - Setup
  
  private func setup() {
    activityIndicator.hidesWhenStopped = true
    activityIndicator.startAnimating()
    
    imagesCollectionView.register(UINib.init(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "CustomImageCell")
    
    imagesCollectionView.delegate = self
    imagesCollectionView.dataSource = self
    
    DispatchQueue.global().async { [weak self] in
      self?.pixabayService.performRequest { (itemsCount) in
        DispatchQueue.main.async {
          self?.cellsCount = itemsCount
          self?.activityIndicator.stopAnimating()
        }
      }
    }
  }
  
}

extension ImagesViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cellsCount
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomImageCell", for: indexPath) as? ImageCell else { fatalError() }
    cell.customImageView.frame = cell.bounds
    
    if let url = pixabayService.webFormat(index: indexPath.row) {
      cell.customImageView.pixabayLoader(url: url)
    }
    
    return cell
  }
  
}

extension ImagesViewController: UICollectionViewDelegateFlowLayout {
  
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

extension ImagesViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let url = pixabayService.webFormat(index: indexPath.row) else { return }
    pixabayService.load(url: url) { (image) in
      DispatchQueue.main.async { [weak self] in
        self?.imageDelegate.setImage(image: image)
        self?.dismiss(animated: true, completion: nil)
      }
    }
    
  }
}
