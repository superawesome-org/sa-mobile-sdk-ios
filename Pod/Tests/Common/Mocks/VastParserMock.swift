//
//  VastParserMock.swift
//  SuperAwesome-Unit-Full-Tests
//
//  Created by Gunhan Sancar on 28/10/2020.
//

@testable import SuperAwesome

struct VastParserMock: VastParserType {
    let firstVast: VastAd
    let secondVast: VastAd
    
    func parse(_ data: Data) -> VastAd {
        if String(decoding: data, as: UTF8.self).contains("first") {
            return firstVast
        } else {
            return secondVast
        }
    }
}
