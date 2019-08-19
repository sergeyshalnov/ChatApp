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
  @IBOutlet private(set) weak var messageTextField: CATextField!
  @IBOutlet private weak var messageContainerView: UIView!
  @IBOutlet private weak var messageContainerBottomConstraint: NSLayoutConstraint!
  
  private(set) lazy var sendButton = makeSendButton()
  
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
    
    NSLayoutConstraint.activate([sendButton.heightAnchor.constraint(equalTo: messageTextField.heightAnchor),
                                 sendButton.widthAnchor.constraint(equalToConstant: size.width + 20)])
  }
  
}

// MARK: - Makers

private extension ConversationView {
  
  func makeSendButton() -> UIButton {
    let button = UIButton()
    
    button.decorate(with: Decorator.Button.Regular())
    button.setTitle("SEND_WORD".localized(), for: .normal)
    
    return button
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

// MARK: - Update

extension ConversationView {
  
  func updateLayout() {
    DispatchQueue.main.async { [weak self] in
      self?.sendButton.cornerRadius(10)
    }
  }
  
}
