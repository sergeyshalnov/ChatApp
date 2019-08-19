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
  
  @IBOutlet private weak var containerView: UIView!
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var messageLabel: UILabel!
  @IBOutlet private weak var timeLabel: UILabel!
  
  // MARK: - Lifecycle
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    DispatchQueue.main.async { [weak self] in
      self?.containerView.cornerRadius(10)
    }
  }
  
  // MARK: - Overriden
  
  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    super.setHighlighted(highlighted, animated: animated)
    
    let animation = { [weak self] in
      if highlighted {
        self?.containerView.backgroundColor = UIColor.Palette.Grey.bubble
      } else {
        self?.containerView.backgroundColor = UIColor.Palette.Blue.online
      }
    }
    
    UIView.animate(withDuration: 0.1,
                   delay: 0,
                   options: .transitionCrossDissolve,
                   animations: animation,
                   completion: nil)
  }
  
}

// MARK: - ITableViewModelRepresentable

extension ConversationCell: ITableViewModelRepresentable {
  
  func updateContent(with model: ITableViewModel) {
    guard let conversation = model as? Conversation else {
      return
    }
    
    selectionStyle = .none
    
    updateUsername(with: conversation.user)
    updateDate(with: conversation)
    updateMessage(with: conversation)
  }
  
}

// MARK: - Updating

private extension ConversationCell {
  
  func updateUsername(with user: User?) {
    containerView.backgroundColor = UIColor.Palette.Blue.online
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
      messageLabel.text = prefix(isIncoming: message.isIncoming) + message.text
    } else {
      messageLabel.font = UIFont.italicSystemFont(ofSize: 17.0)
      messageLabel.text = String.noMessagesWord
    }
  }
  
  func prefix(isIncoming: Bool) -> String {
    return isIncoming ? "" : String.conversationPreviewPrefixWord
  }
  
}

// MARK: - Private String

private extension String {
  
  static let noMessagesWord = "NO_MESSAGES_WORD".localized()
  static let conversationPreviewPrefixWord = "CONVERSATION_PREVIEW_PREFIX".localized()
  
}
