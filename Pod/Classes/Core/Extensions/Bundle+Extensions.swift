//
//  Bundle+Extensions.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 21/04/2020.
//

extension Bundle {
    var versionNumber: String? { infoDictionary?["CFBundleShortVersionString"] as? String }
    var name: String? { infoDictionary?["CFBundleName"] as? String }
}
