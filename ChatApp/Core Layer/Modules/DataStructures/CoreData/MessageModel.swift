//
//  MessageData.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 15/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation

final public class MessageModel: NSObject, Codable, NSCoding {
  
  // MARK: - Variables
  
  let id: String
  let text: String
  let date: Date
  var isIncoming: Bool
  
  // MARK: - Init
  
  init(id: String, text: String, date: Date = Date(), isIncoming: Bool) {
    self.id = id
    self.text = text
    self.date = date
    self.isIncoming = isIncoming
  }
  
  // MARK: - NSCoding
  
  public func encode(with aCoder: NSCoder) {
    aCoder.encode(id, forKey: "id")
    aCoder.encode(text, forKey: "text")
    aCoder.encode(date, forKey: "date")
    aCoder.encode(isIncoming, forKey: "isIncoming")
  }
  
  public convenience init?(coder aDecoder: NSCoder) {
    guard
      let id = aDecoder.decodeObject(forKey: "id") as? String,
      let text = aDecoder.decodeObject(forKey: "text") as? String,
      let date = aDecoder.decodeObject(forKey: "date") as? Date,
      let isIncoming = aDecoder.decodeObject(forKey: "isIncoming") as? Bool
      else {
        return nil
    }
    
    self.init(id: id, text: text, date: date, isIncoming: isIncoming)
  }
  
}
