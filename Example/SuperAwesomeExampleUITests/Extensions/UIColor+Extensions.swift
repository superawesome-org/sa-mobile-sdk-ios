//
//  UIColor+Extensions.swift
//  SuperAwesomeExampleUITests
//
//  Created by Tom O'Rourke on 31/10/2022.
//

import Foundation
import UIKit

extension UIColor {

    func hexStringFromColor() -> String {
        let components = cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        print(hexString)
        return hexString
    }
}
