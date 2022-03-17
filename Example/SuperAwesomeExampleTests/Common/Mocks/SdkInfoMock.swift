//
//  SdkInfoMock.swift
//  SuperAwesome-Unit-Moya-Tests
//
//  Created by Gunhan Sancar on 30/04/2020.
//

@testable import SuperAwesome

class SdkInfoMock: SdkInfoType {
    var version: String = "SdkInfoMockVersion"
    var bundle: String = "SdkInfoMockBundle"
    var name: String = "SdkInfoMockName"
    var lang: String = "SdkInfoMockLang"
}
