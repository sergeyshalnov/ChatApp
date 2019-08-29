//
//  ConversationsListView.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 07/08/2019.
//  Copyright 2019 Sergey Shalnov. All rights reserved.
//

import UIKit

final class ConversationsListView: UIView {
  
  // MARK: - Outlets
  
  @IBOutlet private(set) weak var conversationsTableView: UITableView!
  
}

// MARK: - Setup

extension ConversationsListView {
  
  func setup() {
    let identifier = Conversation.TableViewCell().reuseIdentifier
    
    conversationsTableView.separatorStyle = .none
    conversationsTableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    conversationsTableView.separatorInset = .zero
    conversationsTableView.rowHeight = UITableView.automaticDimension
  }
  
}
