//
//  TestsUtils.swift
//  SAGDPRKisMinor_Tests
//
//  Created by Guilherme Mota on 01/05/2018.
//  Copyright © 2018 GuilhermeMota93. All rights reserved.
//

import Foundation

import Foundation
import SAGDPRKisMinor


enum FixtureError: Error {
    case CannotLoadMainBundle
    case CannotLoadFixturesBundle
    case CannotLoadFixture
    case CannotLoadData
    case CannotParseData
}


func fixtureWithName(name: String, ofType: String = "json") throws -> AnyObject {
    
    guard let testBundle = Bundle(identifier: "org.cocoapods.demo.SAGDPRKisMinor-Tests") else {
        print(FixtureError.CannotLoadMainBundle)
        throw FixtureError.CannotLoadMainBundle
    }
    guard let fixturesBundlePath = testBundle.path(forResource: "fixtures", ofType: "bundle") else {
        print(FixtureError.CannotLoadFixturesBundle)
        throw FixtureError.CannotLoadFixturesBundle
    }
    guard let fixturesBundle = Bundle(path: fixturesBundlePath) else {
        print(FixtureError.CannotLoadFixturesBundle)
        throw FixtureError.CannotLoadFixturesBundle
    }
    guard let path = fixturesBundle.path(forResource: name, ofType: ofType) else {
        print(FixtureError.CannotLoadFixture)
        throw FixtureError.CannotLoadFixture
    }
    guard let data = NSData(contentsOfFile: path) else {
        print(FixtureError.CannotLoadData)
        throw FixtureError.CannotLoadData
    }
    
    do{
        try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
    } catch (let value) {
        print(value)
    }
    
    guard let JSON = try? JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) else {
        print(FixtureError.CannotParseData)
        throw FixtureError.CannotParseData
    }
    
    return JSON as AnyObject
}
