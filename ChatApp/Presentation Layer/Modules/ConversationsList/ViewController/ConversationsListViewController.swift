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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
}

// MARK: - Setup

private extension ConversationsListViewController {
  
  func setup() {
    setupTableView()
    setupNavigationBar()
    
    view().setup()
  }
  
  func setupTableView() {
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
  
  func invite(from peer: MCPeerID, with actions: [UIAlertAction]) {
    alert(title: peer.displayName, message: "INVITE_WORD".localized(), actions: actions)
  }
  
  func display(conversation: Conversation, with session: MCSession) {
    router?.navigate(to: conversation, with: session, animated: true)
  }
  
}
