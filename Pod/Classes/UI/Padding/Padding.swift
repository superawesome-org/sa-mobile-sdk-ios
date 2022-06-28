//
//  Padding.swift
//  SuperAwesome
//
//  Created by Tom O'Rourke on 27/06/2022.
//

import UIKit

internal enum Padding: CGFloat {
    case xxsx = 1.0
    case xxs = 2.0
    case xsx = 3.0
    case xs = 4.0
    case sx = 6.0
    case s = 8.0
    case sm = 12.0
    case m = 16.0
    case l = 32.0
    case xl = 64.0
    case xxl = 128.0

    public var value: CGFloat {
        rawValue
    }

    public var negative: CGFloat {
        -1.0 as CGFloat * rawValue
    }
}
