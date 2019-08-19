//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import UIKit

final class ProfileViewController: UIViewController, CustomViewController {
  typealias RootView = ProfileView
  
  // MARK: - Variables
  
  private var observers: [Any] = []
  
  var output: IProfileViewOutput?
  var router: IProfileRouter?
  
  // MARK: - Deinit
  
  deinit {
    for observer in observers {
      NotificationCenter.default.removeObserver(observer)
    }
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    view().updateLayout()
  }
  
}

// MARK: - Setup

private extension ProfileViewController {
  
  func setup() {
    setupNavigationBar()
    setupKeyboardAppearance()
    view().setup()
    load()
  }
  
  func setupNavigationBar() {
    let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                             target: self,
                                             action: #selector(closeButtonTouch(_:)))
    
    navigationItem.title = String.accountTitleWord
    navigationItem.rightBarButtonItem = rightBarButtonItem
  }
  
  func setupKeyboardAppearance() {
    let willShow = view().keyboardWillShow
    let willHide = view().keyboardWillHide
    let showName = UIResponder.keyboardWillShowNotification
    let hideName = UIResponder.keyboardWillHideNotification
    
    observers.append(NotificationCenter.default.addObserver(view(), selector: willShow, name: showName, object: nil))
    observers.append(NotificationCenter.default.addObserver(view(), selector: willHide, name: hideName, object: nil))
  }
  
}

// MARK: - IBActions

private extension ProfileViewController {
  
  @IBAction func saveAccountButtonTouch(_ sender: Any) {
    save()
  }
  
  @IBAction func updateAccountImageButtonTouch(_ sender: Any) {
    var actions = [UIAlertAction(title: String.cancelWord, style: .cancel)]
    
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      let action = UIAlertAction(title: String.cameraWord, style: .default) { [weak self] _ in
        self?.router?.open(sourceType: .camera, presentationStyle: .fullScreen, animated: true)
      }
      
      actions.append(action)
    }
    
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
      let action = UIAlertAction(title: String.photoLibraryWord, style: .default) { [weak self] _ in
        self?.router?.open(sourceType: .photoLibrary, presentationStyle: .fullScreen, animated: true)
      }
      
      actions.append(action)
    }
    
    actions.append(UIAlertAction(title: String.downloadWord, style: .default) { [weak self] _ in
      self?.router?.navigateToPixabay(animated: true)
    })
    
    alert(title: nil, message: nil, preferredStyle: .actionSheet, actions: actions)
  }
  
  @objc func closeButtonTouch(_ sender: Any) {
    router?.close(animated: true)
  }
  
}

// MARK: - Actions

private extension ProfileViewController {
  
  func load() {
    view().activityIndicator.startAnimating()
    output?.load()
  }
  
  func save() {
    view().activityIndicator.startAnimating()
    output?.save(profile: view().profile())
  }
  
}

// MARK: - IProfileViewInput

extension ProfileViewController: IProfileViewInput {
  
  func display(profile: ProfileData) {
    view().update(profile: profile)
  }
  
  func display(title: String?, message: String, with actions: [UIAlertAction]) {
    alert(title: title, message: message, actions: actions)
  }

  func saveSuccess() {
    view().update(profile: view().profile())
  }
  
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let pickedImage = (info[.editedImage] ?? info[.originalImage]) as? UIImage {
      view().update(image: pickedImage)
    } else {
      let action = UIAlertAction(title: String.okWord, style: .default, handler: nil)
      alert(title: String.errorWord, message: String.imageErrorWord, actions: [action])
    }
    
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
}

// MARK: - IImagePickerDelegate

extension ProfileViewController: IImagePickerDelegate {
  
  func update(with image: UIImage?) {
    view().update(image: image)
  }
  
}

// MARK: - Private String

private extension String {

  static let accountTitleWord = "ACCOUNT_TITLE_WORD".localized()
  static let cancelWord = "CANCEL_WORD".localized()
  static let cameraWord = "CAMERA_WORD".localized()
  static let photoLibraryWord = "PHOTO_LIBRARY_WORD".localized()
  static let downloadWord = "DOWNLOAD_WORD".localized()
  static let okWord = "OK_WORD".localized()
  static let errorWord = "ERROR_WORD".localized()
  static let imageErrorWord = "IMAGE_ERROR_WORD".localized()
  
}
