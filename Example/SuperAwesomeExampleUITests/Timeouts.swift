//
//  Timeouts.swift
//  SuperAwesomeExampleUITests
//
//  Created by Myles Eynon on 17/01/2023.
//

import Foundation

enum Timeout: Double {
    case standard = 5.0
    case extraLong = 30.0

    var duration: Double {
        self.rawValue
    }
}
