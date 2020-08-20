//
//  AppDelegate.swift
//  GitHubAPI
//
//  Created by Pratik on 17/08/20.
//  Copyright © 2020 Pratik. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initialSetup()
        return true
    }
    
    /// Basic inital setup
    private func initialSetup() {
        let path = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory,
                                                       .userDomainMask, true)
        print("Core data path - \(path)")

        //inital screen settings
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let initialVC = UserListViewController()
        //navigation controller set to initial page
        let navigationController = UINavigationController(rootViewController: initialVC)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
}

