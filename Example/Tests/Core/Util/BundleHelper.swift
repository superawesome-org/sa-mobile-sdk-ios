//
//  BundleHelper.swift
//  Tests
//
//  Created by Gunhan Sancar on 16/04/2020.
//

import Foundation
import Mockingjay

func jsonFile(_ name: String) -> Data { BundleHelper.loadFileData(name: name, type: "json") }
func xmlFile(_ name: String) -> Data { BundleHelper.loadFileData(name: name, type: "xml") }

class BundleHelper {
    static func loadFileData(name: String, type: String) -> Data {
        let bundle = Bundle(identifier: "tv.superawesome.Tests")!
        let path = bundle.path(forResource: "fixtures_tests", ofType: "bundle")!

        let data = try? Data(contentsOf: Bundle(path: path)!.url(forResource: name, withExtension: type)!)
        return data!
    }
}
