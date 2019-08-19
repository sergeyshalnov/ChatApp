//
//  PixabayViewController.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 18/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import UIKit

final class PixabayViewController: UIViewController, CustomViewController {
  typealias RootView = PixabayView
  
  // MARK: - Variables
  
  var output: IPixabayViewOutput?
  var router: IPixabayRouter?
  
  weak var delegate: IImagePickerDelegate?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
}

// MARK: - Setup

private extension PixabayViewController {
  
  func setup() {
    setupView()
    setupData()
    setupNavigationBar()
  }
  
  func setupView() {
    view().setup()
    view().activityIndicator.startAnimating()
  }
  
  func setupData() {
    output?.performRequest()
  }
  
  func setupNavigationBar() {
    let rightBarButton = UIBarButtonItem(title: "CANCEL_WORD".localized(),
                                         style: .done,
                                         target: self,
                                         action: #selector(cancelButtonTouch(_:)))
    
    navigationItem.title = "PIXABAY"
    navigationItem.rightBarButtonItem = rightBarButton
  }
  
}

// MARK: - Actions

private extension PixabayViewController {
  
  @objc func cancelButtonTouch(_ sender: Any) {
    router?.close(animated: true)
  }
  
}

// MARK: - IPixabayViewInput

extension PixabayViewController: IPixabayViewInput {
  
  func updateView() {
    view().activityIndicator.stopAnimating()
    view().imagesCollectionView.reloadData()
  }
  
  func display(image: UIImage?) {
    delegate?.update(with: image)
    router?.close(animated: true)
  }
  
}

