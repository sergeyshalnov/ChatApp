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
    
    navigationItem.title = "ACCOUNT_TITLE_WORD".localized()
    navigationItem.rightBarButtonItem = rightBarButtonItem
  }
  
  func setupKeyboardAppearance() {
    let willShow = #selector(view().keyboardWillShow(_:))
    let willHide = #selector(view().keyboardWillHide(_:))
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
    var actions = [UIAlertAction(title: "CANCEL_WORD".localized(), style: .cancel)]
    
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      let action = UIAlertAction(title: "CAMERA_WORD".localized(), style: .default) { [weak self] _ in
        self?.router?.open(sourceType: .camera, presentationStyle: .fullScreen, animated: true)
      }
      
      actions.append(action)
    }
    
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
      let action = UIAlertAction(title: "PHOTO_LIBRARY_WORD".localized(), style: .default) { [weak self] _ in
        self?.router?.open(sourceType: .photoLibrary, presentationStyle: .fullScreen, animated: true)
      }
      
      actions.append(action)
    }
    
    actions.append(UIAlertAction(title: "DOWNLOAD_WORD".localized(), style: .default) { [weak self] _ in
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
      let action = UIAlertAction(title: "OK_WORD".localized(), style: .default, handler: nil)
      alert(title: "ERROR_WORD".localized(), message: "IMAGE_ERROR_WORD".localized(), actions: [action])
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
