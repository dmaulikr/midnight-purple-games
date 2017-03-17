//
//  AppDelegate.swift
//  Hessfield
//
//  Created by caleb on 2/10/16.
//  Copyright © 2016 Midnight Purple Games. All rights reserved.
//

import UIKit
import Fabric
import CoreData
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Fabric.with([Crashlytics.self])
        
        // one signal
//        _ = OneSignal(launchOptions: launchOptions, appId: "beedf0b9-1e57-4d55-8e0f-560f0655ae21", handleNotification: nil)
//        OneSignal.defaultClient().enableInAppAlertNotification(true)
        
        // set up push notifications
//        UIApplication.sharedApplication().registerForRemoteNotifications()
        
// if opened from notifications
//        _ = OneSignal(launchOptions: launchOptions, appId: "3cc2d000-37d7-4472-8ff4-171e82a0ff23") { (message, additionalData, isActive) in
//            if additionalData != nil {
//                if let data = additionalData["pushURL"] as! String? {
//                    self.pushURL = data
//                }
//            }
//        }
        
        return true
    }
}

