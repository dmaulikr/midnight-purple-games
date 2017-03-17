//
//  AppDelegate.swift
//  Optic Blue
//
//  Created by caleb on 2/2/16.
//  Copyright © 2016 Midnight Purple Games. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Fabric.with([Crashlytics.self])
        return true
    }
}

