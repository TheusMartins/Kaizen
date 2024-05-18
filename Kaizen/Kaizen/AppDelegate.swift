//
//  AppDelegate.swift
//  Kaizen
//
//  Created by Scizor on 5/18/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = BetListingController()
        window!.rootViewController = viewController
        window!.makeKeyAndVisible()
        return true
    }
}

