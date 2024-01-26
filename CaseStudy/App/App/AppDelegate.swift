//
//  AppDelegate.swift
//  App
//
//  Created by Koray Yıldız on 16.09.22.
//

import UIKit
import ProductListing

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let view = ProductsViewController()
        let navigator = UINavigationController(rootViewController: view)
        window?.rootViewController = navigator
        window?.makeKeyAndVisible()

        return true
    }
}

