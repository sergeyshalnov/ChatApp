//
//  AppDelegate.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 21.09.2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  // MARK: - Variables
  
  var window: UIWindow?
  
  // MARK: - Private variables
  
  private let rootAssembly = RootAssembly()
  private lazy var coreData: ICoreDataManager = CoreDataManager()
  
  
  // MARK: - Main
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    if UserDefaultsService().get(for: .username) == nil {
      let controller = rootAssembly.presentationAssembly.onboarding()
      
      window?.rootViewController = controller
    } else {
      let controller = rootAssembly.presentationAssembly.conversationsListViewController()
      
      window?.rootViewController = controller
    }
    
    window?.makeKeyAndVisible()
    
    return true
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    UserDefaultsService().remove(for: .username)
    coreData.terminate()
  }
}

