//
//  AppDelegate.swift
//  SuperAwesomeAdMob
//
//  Created by Gunhan Sancar on 06/02/2020.
//  Copyright (c) 2020 Gunhan Sancar. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SuperAwesome

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AwesomeAds.initSDK(true)
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
}
