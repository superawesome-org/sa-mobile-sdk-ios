//
//  Int+Extensions.swift
//  SuperAwesomeExampleUITests
//
//  Created by Tom O'Rourke on 20/04/2023.
//

import Foundation

extension Int {
    static func parse(from string: String) -> Int? {
        return Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
}
