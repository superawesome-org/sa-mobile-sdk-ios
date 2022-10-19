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

    func showQuestionDialog(title: String,
                            message: String,
                            yesTitle: String,
                            noTitle: String,
                            yesAction: VoidBlock?,
                            noAction: VoidBlock?) -> UIAlertController {
        let controller = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)

        let yesUIAction = UIAlertAction(title: yesTitle, style: .default) {_ in
            yesAction?()
        }

        let noUIAction = UIAlertAction(title: noTitle, style: .default) {_ in
            noAction?()
        }

        controller.addAction(yesUIAction)
        controller.addAction(noUIAction)

        self.present(controller, animated: true)

        return controller
    }
}
