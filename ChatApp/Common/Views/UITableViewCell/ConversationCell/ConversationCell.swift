//
//  ConversationsListCell.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 03/10/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit

final class ConversationCell: UITableViewCell {
  
  // MARK: - Outlets
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  
}

// MARK: - ITableViewModelRepresentable

extension ConversationCell: ITableViewModelRepresentable {
  
  func updateContent(with model: ITableViewModel) {
    guard let conversation = model as? Conversation else {
      return
    }
    
    updateUsername(with: conversation.user)
    updateDate(with: conversation)
    updateMessage(with: conversation)
  }
  
}

// MARK: - Updating

private extension ConversationCell {
  
  func updateUsername(with user: User?) {
    backgroundColor = user?.isOnline ?? false ? UIColor.Palette.Blue.online : .white
    titleLabel.text = user?.peer?.displayName
  }
  
  func updateDate(with conversation: Conversation) {
    guard let date = (conversation.messages?.allObjects as? [Message])?.last?.date else {
      return
    }
    
    timeLabel.text = TodayDateFormatter(date: date).label()
  }
  
  func updateMessage(with conversation: Conversation) {
    guard let message = (conversation.messages?.allObjects as? [Message])?.last else {
        return
    }
    
    if message.text.isEmpty() {
      messageLabel.font = UIFont.italicSystemFont(ofSize: 17.0)
    } else {
      messageLabel.font = UIFont.systemFont(ofSize: 17, weight: conversation.isUnread ? .bold : .regular)
    }
    
    messageLabel.textColor = conversation.isUnread ? .black : .darkGray
    messageLabel.text = message.text ?? "NO_MESSAGES_WORD".localized()
  }
  
}

