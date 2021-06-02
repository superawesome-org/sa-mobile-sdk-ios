//
//  TestsUtils.swift
//  SAGDPRKisMinor_Tests
//
//  Created by Guilherme Mota on 01/05/2018.
//  Copyright © 2018 GuilhermeMota93. All rights reserved.
//

import Foundation

enum FixtureError: Error {
    case cannotLoadMainBundle
    case cannotLoadFixturesBundle
    case cannotLoadFixture
    case cannotLoadData
    case cannotParseData
}

func fixtureWithName(name: String, ofType: String = "json") throws -> AnyObject {

    guard let testBundle = Bundle(identifier: "org.cocoapods.demo.SAGDPRKisMinor-Tests") else {
        print(FixtureError.cannotLoadMainBundle)
        throw FixtureError.cannotLoadMainBundle
    }
    guard let fixturesBundlePath = testBundle.path(forResource: "fixtures", ofType: "bundle") else {
        print(FixtureError.cannotLoadFixturesBundle)
        throw FixtureError.cannotLoadFixturesBundle
    }
    guard let fixturesBundle = Bundle(path: fixturesBundlePath) else {
        print(FixtureError.cannotLoadFixturesBundle)
        throw FixtureError.cannotLoadFixturesBundle
    }
    guard let path = fixturesBundle.path(forResource: name, ofType: ofType) else {
        print(FixtureError.cannotLoadFixture)
        throw FixtureError.cannotLoadFixture
    }
    guard let data = NSData(contentsOfFile: path) else {
        print(FixtureError.cannotLoadData)
        throw FixtureError.cannotLoadData
    }

    do {
        try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
    } catch let value {
        print(value)
    }

    guard let JSON = try? JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) else {
        print(FixtureError.CannotParseData)
        throw FixtureError.CannotParseData
    }

    return JSON as AnyObject
}
