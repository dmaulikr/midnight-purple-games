//
//  AppDelegate.swift
//  bacondust2
//
//  Created by caleb on 2/26/16.
//  Copyright © 2016 Midnight Purple Games. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        return true
    }
}

