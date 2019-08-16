//
//  ConversationView.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 11/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import UIKit

final class ConversationView: UIView {
  
  @IBOutlet private(set) weak var tableView: UITableView!
  @IBOutlet private(set) weak var messageTextField: CATextField!
  @IBOutlet private weak var messageContainerView: UIView!
  @IBOutlet private weak var sendButton: UIButton!
  @IBOutlet private weak var messageContainerBottomConstraint: NSLayoutConstraint!
  
}

extension ConversationView {
  
  func setup() {
    sendButton.setImage(UIImage(named: "SendButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
    sendButton.setImage(UIImage(named: "SendButton")?.withRenderingMode(.alwaysTemplate), for: .disabled)
    sendButton.imageView?.contentMode = .scaleAspectFit
  }
  
}

// MARK: - IBActions

private extension ConversationView {
  
  @IBAction func messageTextFieldValueChanged(_ sender: UITextField) {
    sendButton.isEnabled = !sender.text.isEmpty()
  }
  
}

// MARK: - Keyboard Appearance

extension ConversationView {
  
  @objc func keyboardWillShow(_ notification: NSNotification) {
    guard
      let userInfo = notification.userInfo,
      let keyboardSize = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
      let keyboardDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
      else {
        return
    }
    
    UIView.animate(withDuration: keyboardDuration) { [weak self] in
      self?.messageContainerBottomConstraint.constant = keyboardSize.height
      self?.layoutIfNeeded()
    }
  }
  
  @objc func keyboardWillHide(_ notification: NSNotification) {
    messageContainerBottomConstraint.constant = 0
    layoutIfNeeded()
  }
  
}

// MARK: - Disable interface

extension ConversationView {
  
  func disableInterface() {
    messageTextField.isEnabled = false
    sendButton.isEnabled = false 
  }
  
}
