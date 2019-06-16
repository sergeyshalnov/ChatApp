//
//  IncomingCell.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 07/10/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell, ConversationCellConfiguration {
  
  @IBOutlet weak var messageBubble: UITextView!
  
  // MARK: - Layout constant
  
  let cornerRaidus: CGFloat = 18.0
  var edgeInsets: UIEdgeInsets {
    get {
      return UIEdgeInsets.init(top: cornerRaidus / 2, left: cornerRaidus / 2,
                               bottom: cornerRaidus / 2, right: cornerRaidus / 2)
    }
  }
  
  // MARK: - Variables
  
  var message: String? {
    willSet {
      messageBubble.text = newValue
      
      removeConstraints(constraints)
    }
  }
  
  var incoming: Bool = false {
    didSet {
      messageBubble.textContainerInset = edgeInsets
      messageBubble.backgroundColor = incoming ? UIColor.Palette.Bubble.grey : UIColor.Palette.Bubble.blue
      messageBubble.textColor = incoming ? UIColor.black : UIColor.white
      
      messageBubble.translatesAutoresizingMaskIntoConstraints = false
      messageBubble.layer.masksToBounds = true
      messageBubble.layer.cornerRadius = cornerRaidus
      messageBubble.sizeToFit()
      
      setupConstraints()
    }
  }
  
  
  // MARK: - Private functions
  
  private func setupConstraints() { 
    let maxWidth = frame.width * 3/4 - 5
    let minWidth = cornerRaidus * 2 + 5
    
    messageBubble.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth).isActive = true
    messageBubble.widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth).isActive = true
  }
  
  
  // MARK: - Other functions
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
