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
        let environment: Environment = LaunchUtils.shouldRunLocal() ? .uitesting : .production
        AwesomeAds.initSDK(configuration: Configuration(environment: environment, logging: true)) {
            print("AwesomeAds SDK init complete")
        }
    }
}
