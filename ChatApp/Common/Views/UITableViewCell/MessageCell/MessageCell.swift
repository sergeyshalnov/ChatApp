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
  @IBOutlet private weak var containerLeadingConstraint: NSLayoutConstraint!
  @IBOutlet private weak var containerTrailingConstraint: NSLayoutConstraint!
  
}

extension MessageCell: ITableViewModelRepresentable {
  
  func updateContent(with model: ITableViewModel) {
    guard let message = model as? Message else {
      return
    }
    
    messageLabel.text = message.text
    containerTrailingConstraint.isActive = !message.isIncoming
    containerLeadingConstraint.isActive = message.isIncoming
    
    containerView.backgroundColor = message.isIncoming ? UIColor.Palette.Grey.bubble : UIColor.Palette.Blue.bubble
    messageLabel.textColor = message.isIncoming ? .black : .white
    
    DispatchQueue.main.async {
      self.containerView.cornerRadius(15)
    }
  }
  
}
