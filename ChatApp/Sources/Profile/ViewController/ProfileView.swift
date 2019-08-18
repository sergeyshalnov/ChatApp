//
//  ProfileView.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import UIKit

final class ProfileView: UIView {

  // MARK: - Outlets
  
  @IBOutlet private(set) weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet private(set) weak var profileImageView: UIImageView!
  
  @IBOutlet private weak var containerScrollView: UIScrollView!
  @IBOutlet private weak var updateProfileImageButton: UIButton!
  @IBOutlet private weak var usernameTextField: CATextField!
  @IBOutlet private weak var statusTextField: CATextField!
  @IBOutlet private weak var saveProfileButton: UIButton!
  
}

// MARK: - Setup

extension ProfileView {
  
  func setup() {
    setupSendButton()
    setupSaveButton()
  }
  
  private func setupSendButton() {
    guard let size = updateProfileImageButton.titleLabel?.size() else {
      return
    }
    
    let constraints = [updateProfileImageButton.widthAnchor.constraint(equalToConstant: size.width + 20),
                       updateProfileImageButton.heightAnchor.constraint(equalToConstant: size.height + 20)]
    
    updateProfileImageButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(constraints)
  }
  
  private func setupSaveButton() {
    guard let size = saveProfileButton.titleLabel?.size() else {
      return
    }
    
    saveProfileButton.translatesAutoresizingMaskIntoConstraints = false
    saveProfileButton.heightAnchor.constraint(equalToConstant: size.height + 20).isActive = true
  }
  
}

// MARK: - Layout

extension ProfileView {
  
  func updateLayout() {
    DispatchQueue.main.async { [weak self] in
      self?.profileImageView.cornerRadius(10)
      self?.updateProfileImageButton.cornerRadius(10)
      self?.saveProfileButton.cornerRadius(10)
    }
  }
  
  func updateContent(profile: ProfileData) {
    activityIndicator.stopAnimating()
    profileImageView.image = profile.image
    usernameTextField.text = profile.username
    statusTextField.text = profile.information
  }
  
}

// MARK: - Keyboard Appearance

extension ProfileView {
  
  @objc func keyboardWillShow(_ notification: NSNotification) {
    guard
      let userInfo = notification.userInfo,
      let keyboardSize = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
      let keyboardDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
      else {
        return
    }
    
    UIView.animate(withDuration: keyboardDuration) { [weak self] in
      self?.containerScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
      self?.layoutIfNeeded()
    }
  }
  
  @objc func keyboardWillHide(_ notification: NSNotification) {
    containerScrollView.contentInset = .zero
  }
  
}

// MARK: - Public

extension ProfileView {
  
  func profile() -> ProfileData {
    return ProfileData(username: usernameTextField.text,
                       information: statusTextField.text,
                       image: profileImageView.image)
  }
  
}
