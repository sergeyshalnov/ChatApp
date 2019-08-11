//
//  TodayDateFormatter.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 10/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation

class TodayDateFormatter: DateFormatter {
  
  private let date: NSDate?
  
  // MARK: - Init
  
  init(date: NSDate?) {
    self.date = date
    super.init()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  // MARK: - Formatter
  
  func label() -> String? {
    guard let date = date as Date? else {
      return nil
    }
    
    dateFormat = Calendar.current.isDateInToday(date) ? "HH:mm" : "dd MMM"
    
    return string(from: date)
  }
  
}
