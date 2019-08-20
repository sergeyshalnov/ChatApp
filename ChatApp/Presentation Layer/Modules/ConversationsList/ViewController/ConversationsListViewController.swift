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
    output?.startCommunicationService()
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
    navigationItem.title = String.chatsWord
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: Images.contact,
                                                        style: .done,
                                                        target: self,
                                                        action: #selector(profileButtonTouch))
  }
  
}

// MARK: - Actions

private extension ConversationsListViewController {
  
  @objc func profileButtonTouch(_ sender: UIBarButtonItem) {
    router?.profile(animated: true)
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
    alert(title: peer.displayName, message: String.inviteWord, actions: actions)
  }
  
  func display(conversation: Conversation, with session: MCSession) {
    router?.navigate(to: conversation, with: session, animated: true)
  }
  
  func display(title: String, message: String) {
    alert(title: title, message: message, actions: [
      UIAlertAction(title: String.okWord, style: .default, handler: nil)
    ])
  }
  
  func noProfile() {
    router?.onboarding(animated: true)
  }
  
}

// MARK: - Private String

private extension String {
  
  static let chatsWord = "CHATS_WORD".localized()
  static let inviteWord = "INVITE_WORD".localized()
  static let okWord = "OK_WORD".localized()
  
}

// MARK: - Private Images

private struct Images {
  
  static let contact = UIImage(named: "Contact")
  
}
