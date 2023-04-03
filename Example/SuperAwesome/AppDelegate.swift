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
        let testSetup = UITestSetup()

        if testSetup.isInTestMode {
            UIView.setAnimationsEnabled(false)
        }

//        let environment: Environment = testSetup.isInTestMode ? .uitesting : .production
        let environment: Environment = .production
        AwesomeAds.initSDK(configuration: Configuration(environment: environment, logging: true)) {
            print("AwesomeAds SDK init complete")
        }
    }
}
