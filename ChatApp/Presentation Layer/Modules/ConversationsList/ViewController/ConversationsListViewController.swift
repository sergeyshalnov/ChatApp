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
  
  var output: IConversationsListViewOutput? {
    didSet {
      output?.performFetch()
    }
  }
  
  var router: IConversationsListRouter?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
}

// MARK: - Setup

private extension ConversationsListViewController {
  
  func setup() {
    let identifier = Conversation.TableViewCell().reuseIdentifier
    
    view().conversationsTableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    view().conversationsTableView.delegate = self
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
  
  func converse(in conversation: Conversation) {
    router?.navigate(to: conversation, animated: true)
  }
  
}
