//
//  AppDelegate.swift
//  SuperAwesomeExample
//
//  Created by Mark on 04/06/2021.
//

import UIKit
import SuperAwesome
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func applicationDidFinishLaunching(_ application: UIApplication) {
        AwesomeAds.initSDK(configuration: Configuration(environment: .production, logging: true)) {
            print("AwesomeAds SDK init complete")
        }
    }
}
