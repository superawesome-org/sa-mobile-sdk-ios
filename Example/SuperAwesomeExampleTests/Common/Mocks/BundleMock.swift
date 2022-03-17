//
//  BundleMock.swift
//  Tests
//
//  Created by Gunhan Sancar on 21/04/2020.
//

@testable import SuperAwesome

class BundleMock: Bundle {
    var mockName: String = ""
    var mockBundleId: String = ""
    var mockVersionNumber: String = ""
    var mockLocalizations: [String] = []

    static func make(name: String, bundleId: String, versionNumber: String, localizations: [String]) -> BundleMock {
        let bundle = BundleMock()
        bundle.mockName = name
        bundle.mockBundleId = bundleId
        bundle.mockVersionNumber = versionNumber
        bundle.mockLocalizations = localizations
        return bundle
    }

    override var preferredLocalizations: [String] { mockLocalizations }
    override var bundleIdentifier: String? { mockBundleId }
    override var name: String { mockName}
    override var versionNumber: String { mockVersionNumber }
}
