//
//  EventHandler.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 02/12/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit

@objc(EventHandler) class EventHandler: UIApplication {
  
  private lazy var emblemGenerator = EmblemGenerator()
  
  // MARK: - Event Handler
  
  override func sendEvent(_ event: UIEvent) {
    if event.type == .touches {
      guard let touch = event.allTouches?.first else {
        super.sendEvent(event)
        return
      }
      
      if let touches = event.allTouches {
        for touch in touches.enumerated() {
          if touch.element.phase == .cancelled || touch.element.phase == .ended {
            emblemGenerator.stop()
            break
          }
        }
      }
      
      emblemGenerator.start(with: touch)
    }
    
    super.sendEvent(event)
  }
}
