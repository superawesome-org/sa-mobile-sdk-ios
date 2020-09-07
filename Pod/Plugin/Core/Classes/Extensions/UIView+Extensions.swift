//
//  UIView+Extensions.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 24/08/2020.
//

import UIKit

extension UIView {
    func registerForOrientationDidChangeNotification(_ block: @escaping (Notification) -> Void) {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("UIDeviceOrientationDidChangeNotification"),
            object: nil,
            queue: nil,
            using: block)
    }
    
    func unregisterForOrientationDidChangeNotification() {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name("UIDeviceOrientationDidChangeNotification"),
            object: nil)
    }
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        } else {
            return topAnchor
        }
    }
    
    var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.trailingAnchor
        } else {
            return trailingAnchor
        }
    }
}
