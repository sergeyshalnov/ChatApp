//
//  Alert.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 27/10/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit


// MARK: - Alerts for non-escaping completion

class Alert {
  
  enum Message: String {
    case cameraError = "Отсутствует доступ к камере"
    case libraryError = "Отсутствует доступ к галерее"
    case imageError = "Некорректное изображение"
    case saveDone = "Данные успешно сохранены"
    case saveError = "Не удалось сохранить данные"
    case invitation = "Пользователь послал вам приглашение"
  }
  
  static func controller(type: Alert.Message,
                         left: ((UIAlertAction) -> Void)? = nil,
                         right: ((UIAlertAction) -> Void)? = nil) -> UIAlertController{
    var title: String
    
    switch type {
    case .saveDone:
      title = "Данные успешно сохранены"
    default:
      title = "Ошибка"
    }
    
    let alert = UIAlertController(title: title, message: type.rawValue, preferredStyle: .alert)
    
    switch type {
    case .saveError: 
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: left))
      alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: right))
    default:
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: left))
    }
    
    return alert
  }
  
}
