//
//  IncomingCell.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 07/10/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
  
  // MARK: - Outlets
  
  @IBOutlet private weak var containerView: UIView!
  @IBOutlet private weak var messageLabel: UILabel!
  
  private var leadingConstraint: NSLayoutConstraint?
  private var trailingConstraint: NSLayoutConstraint?
  
  override func awakeFromNib() {
    leadingConstraint = containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5)
    trailingConstraint = containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
  }
  
}

extension MessageCell: ITableViewModelRepresentable {
  
  func updateContent(with model: ITableViewModel) {
    guard let message = model as? Message else {
      return
    }
    
    messageLabel.text = message.text
    
    trailingConstraint?.isActive = !message.isIncoming
    leadingConstraint?.isActive = message.isIncoming
    
    containerView.backgroundColor = message.isIncoming ? UIColor.Palette.Grey.bubble : UIColor.Palette.Blue.bubble
    messageLabel.textColor = message.isIncoming ? .black : .white
    
    DispatchQueue.main.async {
      self.containerView.cornerRadius(10)
    }
  }
  
}
