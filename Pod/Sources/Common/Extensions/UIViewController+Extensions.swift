//
//  UIViewController+Extensions.swift
//  Alamofire
//
//  Created by Gunhan Sancar on 02/09/2020.
//

import UIKit

extension UIViewController {
    
    /// Present the caller viewcontroller in a new `UIWindow` and return the window
    func presentInNewWindow() -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController()
        window.windowLevel = UIWindow.Level(UIWindow.Level.alert.rawValue + 1)
        window.makeKeyAndVisible()
        window.rootViewController?.present(self, animated: true)
        return window
    }
}
