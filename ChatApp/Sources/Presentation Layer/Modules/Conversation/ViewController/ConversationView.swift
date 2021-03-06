//
//  ConversationView.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 11/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import UIKit

final class ConversationView: UIView {
  
  // MARK: - Outlets
  
  @IBOutlet private(set) weak var tableView: UITableView!
  @IBOutlet private weak var messageTextField: CATextField!
  @IBOutlet private weak var messageContainerView: UIView!
  @IBOutlet private weak var messageContainerBottomConstraint: NSLayoutConstraint!
  
  private(set) lazy var sendButton = makeSendButton()
  
  // MARK: - Overriden
  
  override func layoutSubviews() {
    super.layoutSubviews()
    sendButton.cornerRadius(10)
  }
  
}

// MARK: - Setup

extension ConversationView {
  
  func setup() {
    setupTableView()
    setupSendButton()
  }
  
  func setupTableView() {
    let identifier = Message.TableViewCell().reuseIdentifier
    
    tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 60
    tableView.allowsSelection = false
  }
  
  func setupSendButton() {
    guard let size = sendButton.titleLabel?.size() else {
      return
    }
    
    messageTextField.addSubview(sendButton)
    messageTextField.rightView = sendButton
    messageTextField.rightViewMode = .always
    messageTextField.padding.right = size.width + 20
    
    sendButton.translatesAutoresizingMaskIntoConstraints = false
    sendButton.isEnabled = false
    
    NSLayoutConstraint.activate([
      sendButton.heightAnchor.constraint(equalTo: messageTextField.heightAnchor),
      sendButton.widthAnchor.constraint(equalToConstant: size.width + 20
    )])
  }
  
}

// MARK: - Makers

private extension ConversationView {
  
  func makeSendButton() -> UIButton {
    let button = UIButton()
    
    button.decorate(with: Decorator.Button.Regular())
    button.setTitle(String.sendWord, for: .normal)
    
    return button
  }
  
}

// MARK: - IBActions

private extension ConversationView {
  
  @IBAction func messageTextFieldEditingChanged(_ sender: UITextField) {
    sendButton.isEnabled = !sender.text.isEmpty()
  }
  
}

// MARK: - Public

extension ConversationView {
  
  func message() -> String? {
    defer {
      messageTextField.text = nil
      sendButton.isEnabled = false
    }
    
    return messageTextField.text
  }
  
}

// MARK: - Keyboard Appearance

extension ConversationView {
  
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
      guard let self = self else {
        return
      }
      
      self.messageContainerBottomConstraint.constant = keyboardSize.height - self.safeAreaInsets.bottom
      self.layoutIfNeeded()
    }
  }
  
  @objc private func keyboardWillHide(_ notification: NSNotification) {
    messageContainerBottomConstraint.constant = 0
    layoutIfNeeded()
  }
  
}

// MARK: - Private String

private extension String {
  
  static let sendWord = "SEND_WORD".localized()
  
}
