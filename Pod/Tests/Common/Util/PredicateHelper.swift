//
//  PredicateHelper.swift
//  SuperAwesome-Unit-Full-Tests
//
//  Created by Gunhan Sancar on 28/10/2020.
//

import Foundation
import Nimble

public func equalSmart<T: Equatable>(_ expectedValue: T?) -> Predicate<T> {
    if expectedValue == nil {
        return beNil()
    } else {
        return equal(expectedValue)
    }
}
