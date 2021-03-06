//
//  AppDelegate.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 21.09.2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
  
  // MARK: - Variables
  
  var window: UIWindow?
  
  // MARK: - Private variables
  
  private let rootAssembly = RootAssembly()
  private lazy var coreData: ICoreDataManager = CoreDataManager()
  
  // MARK: - Main
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    UINavigationBar.appearance().barTintColor = .white
    
    window?.rootViewController = rootAssembly.presentationAssembly.conversationsList()
    window?.makeKeyAndVisible()
    
    return true
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    coreData.terminate()
  }
  
}

