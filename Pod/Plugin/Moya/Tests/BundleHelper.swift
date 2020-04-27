//
//  BundleHelper.swift
//  SuperAwesome-Unit-Moya-Tests
//
//  Created by Gunhan Sancar on 27/04/2020.
//

import XCTest
import Nimble
import Moya
import Mockingjay
@testable import SuperAwesome

func jsonFile(_ name: String) -> Data { BundleHelper.loadFileData(name: name, type: "json") }
func xmlFile(_ name: String) -> Data { BundleHelper.loadFileData(name: name, type: "xml") }

class BundleHelper {
    static func loadFileData(name: String, type: String) -> Data {
        let bundle = Bundle(for: AwesomeAdsApiTests.self)
        let path = bundle.path(forResource: "fixtures_tests", ofType: "bundle")!

        let data = try? Data(contentsOf: Bundle(path: path)!.url(forResource: name, withExtension: type)!)
        return data!
    }
}

func makeAdQuery() -> AdQuery { AdQuery(test: true, sdkVersion: "", rnd: 1, bundle: "",
                                        name: "", dauid: 1, ct: .wifi, lang: "", device: "",
                                        pos: 1, skip: 1, playbackmethod: 1, startdelay: 1, instl: 1, w: 1, h: 1) }
