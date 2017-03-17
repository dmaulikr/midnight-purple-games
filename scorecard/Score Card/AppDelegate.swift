//
//  AppDelegate.swift
//  Score Card
//
//  Created by caleb on 7/14/15.
//  Copyright (c) 2015 Midnight Purple Games. All rights reserved.
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

