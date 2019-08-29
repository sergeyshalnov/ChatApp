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

  @IBOutlet private weak var containerScrollView: UIScrollView!
  @IBOutlet private weak var profileImageView: UIImageView!
  @IBOutlet private weak var updateProfileImageButton: UIButton!
  @IBOutlet private weak var usernameTextField: CATextField!
  @IBOutlet private weak var statusTextField: CATextField!
  @IBOutlet private weak var saveProfileButton: UIButton!
  @IBOutlet private weak var noPhotoLabel: UILabel!
  
  // MARK: - Variables
  
  private var temporaryProfile: ProfileData?
  
  // MARK: - Lifecycle
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    profileImageView.cornerRadius(10)
    updateProfileImageButton.cornerRadius(10)
    saveProfileButton.cornerRadius(10)
  }
  
}

// MARK: - Setup

extension ProfileView {
  
  func setup() {
    setupUpdateButton()
    setupSaveButton()
    setupNoPhotoLabel()
  }
  
  private func setupUpdateButton() {
    guard let size = updateProfileImageButton.titleLabel?.size() else {
      return
    }
    
    updateProfileImageButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      updateProfileImageButton.widthAnchor.constraint(equalToConstant: size.width + 20),
      updateProfileImageButton.heightAnchor.constraint(equalToConstant: size.height + 20)
    ])
  }
  
  private func setupSaveButton() {
    guard let size = saveProfileButton.titleLabel?.size() else {
      return
    }
    
    saveProfileButton.decorate(with: Decorator.Button.Regular())
    saveProfileButton.translatesAutoresizingMaskIntoConstraints = false
    saveProfileButton.heightAnchor.constraint(equalToConstant: size.height + 20).isActive = true
  }
  
  private func setupNoPhotoLabel() {
    noPhotoLabel.textColor = UIColor.Palette.Grey.placeholder
  }
  
}

// MARK: - Layout

extension ProfileView {
  
  func update(profile: ProfileData) {
    temporaryProfile = profile
    activityIndicator.stopAnimating()
    profileImageView.image = profile.image
    usernameTextField.text = profile.username
    statusTextField.text = profile.information
    saveProfileButton.isEnabled = false
    noPhotoLabel.isHidden = profile.image != nil
  }
  
  func update(image: UIImage?) {
    profileImageView.image = image
    saveProfileButton.isEnabled = true
    noPhotoLabel.isHidden = image != nil
  }
  
}

// MARK: - Keyboard Appearance

extension ProfileView {
  
  var keyboardWillShow: Selector {
    return #selector(keyboardWillShow(_:))
  }
  
  var keyboardWillHide: Selector {
    return #selector(keyboardWillHide(_:))
  }
  
  @objc private func keyboardWillShow(_ notification: NSNotification) {
    guard
      let userInfo = notification.userInfo,
      let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
      let keyboardDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
      else {
        return
    }
    
    UIView.animate(withDuration: keyboardDuration) { [weak self] in
      self?.containerScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
      self?.layoutIfNeeded()
    }
  }
  
  @objc private func keyboardWillHide(_ notification: NSNotification) {
    containerScrollView.contentInset = .zero
  }
  
}

// MARK: - IBActions

private extension ProfileView {
  
  @IBAction func usernameTextFieldEditingChanged(_ sender: Any) {
    saveProfileButton.isEnabled = profile() != temporaryProfile
  }
  
  @IBAction func statusTextFieldEditingChanged(_ sender: Any) {
    saveProfileButton.isEnabled = profile() != temporaryProfile
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
