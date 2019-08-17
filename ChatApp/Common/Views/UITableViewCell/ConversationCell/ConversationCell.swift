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
    if let message = conversation.preview {
      messageLabel.font = UIFont.systemFont(ofSize: 17, weight: conversation.isUnread ? .bold : .regular)
      messageLabel.textColor = conversation.isUnread ? .black : .darkGray
      
      if let text = message.text {
        messageLabel.text = prefix(isIncoming: message.isIncoming) + text
      } else {
        messageLabel.text = "NO_MESSAGES_WORD".localized()
      }
    } else {
      messageLabel.font = UIFont.italicSystemFont(ofSize: 17.0)
      messageLabel.text = "NO_MESSAGES_WORD".localized()
    }
  }
  
  func prefix(isIncoming: Bool) -> String {
    return isIncoming ? "" : "CONVERSATION_PREVIEW_PREFIX".localized()
  }
  
}

