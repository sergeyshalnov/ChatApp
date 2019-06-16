//
//  CoreDataManager+IProfileStorage.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 16/06/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit
import CoreData


// MARK: - IProfileStorage extension

extension CoreDataManager: IProfileStorage {
  
  func load(completion: @escaping (ProfileData?) -> Void) {
    CoreDataManager.container.performBackgroundTask { (backgroundContext) in
      let request: NSFetchRequest<Profile> = Profile.fetchRequest()
      
      do {
        let result = try backgroundContext.fetch(request)
        let data = result.first
        
        var image: UIImage? = nil
        
        if let url = data?.image {
          let imageLoader: IImageLoader = ImageManager()
          
          image = imageLoader.load(filename: url)
        }
        
        completion(ProfileData(username: data?.username, information: data?.information, image: image))
      } catch {
        completion(nil)
      }
    }
  }
  
  func save(profile: ProfileData, completion: @escaping (Bool) -> Void) {
    CoreDataManager.container.performBackgroundTask { (backgroundContext) in
      let request: NSFetchRequest<Profile> = Profile.fetchRequest()
      
      do {
        let result = try backgroundContext.fetch(request)
        var success = true
        
        if result.isEmpty {
          let entity = Profile(context: backgroundContext)
          
          if let username = profile.username {
            entity.username = username
          }
          
          if let information = profile.information {
            entity.information = information
          }
          
          if let image = profile.image {
            let imageSaver: IImageSaver = ImageManager()
            
            success = imageSaver.save(image: image, filename: FileName.image.rawValue)
            entity.image = success ? FileName.image.rawValue : nil
          }
        } else {
          let entity = result.first
          
          if let username = profile.username {
            entity?.setValue(username, forKey: "username")
          }
          
          if let information = profile.information {
            entity?.setValue(information, forKey: "information")
          }
          
          if let image = profile.image {
            let imageSaver: IImageSaver = ImageManager()
            
            success = imageSaver.save(image: image, filename: FileName.image.rawValue)
            entity?.setValue(FileName.image.rawValue, forKey: "image")
          }
        }
        
        try backgroundContext.save()
        
        completion(success)
      } catch {
        completion(false)
        
        return
      }
    }
  }
}
