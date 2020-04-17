//
//  SdkInfo.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 17/04/2020.
//

protocol SdkInfoType {
    var version: String { get }
    var bundle: String { get }
    var name: String { get }
    var lang: String { get }
}

struct SdkInfo: SdkInfoType {
    var version: String
    var bundle: String
    var name: String
    var lang: String
    
    init() {
        self.version = ""
        self.bundle = ""
        self.name = ""
        self.lang = ""
    }
}
