//
//  BundleHelper.swift
//  Tests
//
//  Created by Gunhan Sancar on 16/04/2020.
//

import Foundation

func jsonFile(_ name: String) -> Data { BundleHelper.loadFileData(name: name, type: "json") }
func xmlFile(_ name: String) -> Data { BundleHelper.loadFileData(name: name, type: "xml") }

class BundleHelper {
    static func loadFileData(name: String, type: String) -> Data {
                
        let testBundle = Bundle(for: self)
        if let path = testBundle.path(forResource: "fixtures_tests", ofType: "bundle"),
           let innerBundle = Bundle(path: path),
           let fixturesUrl = innerBundle.url(forResource: name, withExtension: type),
           let data = try? Data(contentsOf: fixturesUrl) {
            return data
        }
        
        // Swift Package File Resolver
        
        guard let testSubBundlePath = testBundle.path(forResource: "SuperAwesome_sa-mobile-sdk-iosTests", ofType: "bundle"),
              let testsSubBundle = Bundle(path: testSubBundlePath),
              let fixturesBundlePath = testsSubBundle.path(forResource: "fixtures_tests", ofType: "bundle"),
              let fixturesBundle = Bundle(path: fixturesBundlePath),
              let fixturesUrl = fixturesBundle.url(forResource: name, withExtension: type),
              let data = try? Data(contentsOf: fixturesUrl) else {
                  return Data()
        }

        return data
    }
}
