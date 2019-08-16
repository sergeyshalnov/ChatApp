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
  
}

// MARK: - Setup

private extension ConversationViewController {
  
  func setup() {
    setupKeyboardAppearance()
    setupTableView()
    
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
  
  func setupTableView() {
    let identifier = Message.TableViewCell().reuseIdentifier
    
    view().tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    view().tableView.rowHeight = UITableView.automaticDimension
    view().tableView.estimatedRowHeight = 60
    view().tableView.allowsSelection = false
  }
  
}

// MARK: - IBActions

extension ConversationViewController {
  
  @IBAction func sendButtonTouch(_ sender: Any) {
    guard let message = view().messageTextField.text else {
      return
    }
    
    output?.send(message: message)
  }
  
}

// MARK: - IConversationViewInput

extension ConversationViewController: IConversationViewInput {
 
  func disableInterface() {
    view().disableInterface()
  }
  
}
