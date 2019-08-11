//
//  EmblemGenerator.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 02/12/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit


// MARK: - Emblem Generator

class EmblemGenerator {
  
  private var timer: Timer?
  
  // MARK: - Animation
  
  private func animate(object: UIView) {
    UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
      object.transform = .identity
    }, completion: nil)
    
    UIView.animateKeyframes(withDuration: 2, delay: 0, options: [], animations: {
      let x = object.layer.position.x - 25 + Generator.number(from: -35, to: 35)
      let y = object.layer.position.y - 25 + Generator.number(from: -35, to: 35)
      
      object.frame = CGRect(x: x, y: y, width: 50, height: 50)
    }, completion: nil)
    
    UIView.animateKeyframes(withDuration: 0.5, delay: 1.5, options: [], animations: {
      object.alpha = 0
    }, completion: { _ in
      object.removeFromSuperview()
    })
  }
  
  // MARK: - Functions
  
  func start(with touch: UITouch) {
    if timer != nil { return }
    
    guard let view = touch.view?.superview else { return }
    
    let position = touch.location(in: view)
    
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [weak self] _ in
      let image = UIImage(named: "Emblem")
      let imageView = UIImageView(image: image)
      
      imageView.contentMode = .scaleAspectFill
      imageView.frame = CGRect(x: position.x - 25, y: position.y - 25, width: 50, height: 50)
      imageView.transform = CGAffineTransform(scaleX: 0, y: 0)
      
      self?.animate(object: imageView)
      
      view.addSubview(imageView)
    })
  }
  
  func stop() {
    DispatchQueue.main.async { [weak self] in
      self?.timer?.invalidate()
      self?.timer = nil
    }
    
  }
  
}
