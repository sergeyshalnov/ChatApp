//
//  ConversationsListViewController.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 07/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import UIKit
import MultipeerConnectivity.MCPeerID

final class ConversationsListViewController: UIViewController, CustomViewController {
  typealias RootView = ConversationsListView
  
  // MARK: - Variables
  
  var router: IConversationsListRouter?
  var output: IConversationsListViewOutput? {
    didSet {
      output?.performFetch()
    }
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
  }
  
}

// MARK: - Setup

private extension ConversationsListViewController {
  
  func setup() {
    setupTableView()
    setupNavigationBar()
  }
  
  func setupTableView() {
    let identifier = Conversation.TableViewCell().reuseIdentifier
    
    view().conversationsTableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    view().conversationsTableView.delegate = self
  }
  
  func setupNavigationBar() {
    navigationItem.title = "CHATS_WORD".localized()
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Contact"),
                                                        style: .done,
                                                        target: self,
                                                        action: #selector(profileButtonTouch))
  }
  
}

// MARK: - Actions

private extension ConversationsListViewController {
  
  @objc dynamic func profileButtonTouch(_ sender: UIBarButtonItem) {
    router?.profile()
  }
  
}

// MARK: - UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    output?.selectedItem(at: indexPath)
  }
  
}

// MARK: - IConversationsListViewInput

extension ConversationsListViewController: IConversationsListViewInput {
  
  func display(alert: UIAlertController) {
    present(alert, animated: true)
  }
  
  func converse(in conversation: Conversation, with session: MCSession) {
    router?.navigate(to: conversation, with: session, animated: true)
  }
  
}
