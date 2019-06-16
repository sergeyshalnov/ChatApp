//
//  ConversationsListCell.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 03/10/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit

class ConversationsListCell: UITableViewCell, ConversationListCellConfiguration {
  
  // MARK: - Outlets
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  
  // MARK: - Protocol configuration
  
  var name: String? {
    willSet {
      titleLabel.text = newValue
      
      messageLabel.textColor = UIColor.darkGray
    }
  }
  
  var message: String? {
    willSet {
      if newValue == nil {
        messageLabel.text = "No messages yet"
        messageLabel.font = UIFont.italicSystemFont(ofSize: 17.0)
      } else {
        messageLabel.text = newValue
      }
    }
  }
  
  var date: Date? {
    willSet {
      if let value = newValue {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = isToday(date: value) ? "HH:mm" : "dd MMM"
        timeLabel.text = dateFormatterPrint.string(from: value)
      } else {
        timeLabel.text = ""
      }
    }
  }
  
  var online: Bool {
    willSet {
      if newValue {
        self.backgroundColor = UIColor.Palette.Blue.online
      } else {
        self.backgroundColor = .white
      }
    }
  }
  
  var wasUnreadMessages: Bool {
    willSet {
      if newValue && message != nil {
        messageLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        messageLabel.textColor = UIColor.black
      } else if message != nil {
        messageLabel.font = UIFont.systemFont(ofSize: 17.0)
        messageLabel.textColor = UIColor.darkGray
      }
    }
  }
  
  // MARK: - Peer
  
  var peer: Peer?
  var conversationId: String?
  
  // MARK: - Initialization
  
  required init?(coder aDecoder: NSCoder) {
    self.online = false
    self.wasUnreadMessages = false
    
    super.init(coder: aDecoder)
  }
  
  
  // MARK: - Private functions
  
  private func isToday(date: Date) -> Bool {
    let calendarComponents: Set<Calendar.Component> = [.day, .month, .year]
    let A = Calendar.current.dateComponents(calendarComponents, from: date)
    let B = Calendar.current.dateComponents(calendarComponents, from: Date())
    
    return A.day == B.day && A.month == B.month && A.year == B.year ? true : false
  }
  
  
  // MARK: - Other functions
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
