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

    var window: UIWindow?
    
    private let rootAssembly = RootAssembly()
    private lazy var coreData: ICoreDataManager = CoreDataManager()
    
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let controller = rootAssembly.presentationAssembly.conversationsListViewController()
    
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
        
        coreData.terminate()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Application will terminate
    }
}

