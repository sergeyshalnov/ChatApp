//
//  ConversationViewController.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 11/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import UIKit

final class ConversationViewController: UIViewController, CustomViewController {
  typealias RootView = ConversationView
  
  // MARK: - Variables
  
  private var observers: [Any] = []
  
  var router: IConversationRouter?
  var output: IConversationViewOutput? {
    didSet {
      output?.performFetch()
    }
  }
  
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
    navigationController?.navigationBar.prefersLargeTitles = false
  }
  
}

// MARK: - Setup

private extension ConversationViewController {
  
  func setup() {
    setupKeyboardAppearance()
    setupSendButton()
    
    view().setup()
  }
  
  func setupKeyboardAppearance() {
    let willShow = #selector(view().keyboardWillShow(_:))
    let willHide = #selector(view().keyboardWillHide(_:))
    let showName = UIResponder.keyboardWillShowNotification
    let hideName = UIResponder.keyboardWillHideNotification
    
    observers.append(NotificationCenter.default.addObserver(view(), selector: willShow, name: showName, object: nil))
    observers.append(NotificationCenter.default.addObserver(view(), selector: willHide, name: hideName, object: nil))
  }
  
  func setupSendButton() {
    view().sendButton.addTarget(self, action: #selector(sendButtonTouch(_:)), for: .touchUpInside)
  }
  
}

// MARK: - IBActions

private extension ConversationViewController {
  
  @IBAction func messageTextFieldValueChanged(_ sender: UITextField) {
    view().sendButton.isEnabled = !sender.text.isEmpty()
  }
  
  @objc func sendButtonTouch(_ sender: Any) {
    guard let message = view().messageTextField.text else {
      return
    }
    
    output?.send(message: message)
    view().messageTextField.text = nil
  }
  
}

// MARK: - IConversationViewInput

extension ConversationViewController: IConversationViewInput {
  
  func disconnected(from conversation: Conversation) {
    let action = UIAlertAction(title: "OK_WORD".localized(), style: .default) { [weak self] _ in
      self?.router?.close(animated: true)
    }
    
    alert(title: conversation.user?.peer?.displayName, message: "DISCONNECTED_WORD".localized(), actions: [action])
  }
  
}
