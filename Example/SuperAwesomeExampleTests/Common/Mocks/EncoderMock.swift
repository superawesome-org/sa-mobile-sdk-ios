//
//  EncoderMock.swift
//  SuperAwesome-Unit-Moya-Tests
//
//  Created by Gunhan Sancar on 30/04/2020.
//

@testable import SuperAwesome

class EncoderMock: EncoderType {
    func encodeUri(_ string: String?) -> String {
        return "EncoderMockEncodeUri"
    }

    func toJson<T>(_ encodable: T) -> String? where T: Encodable {
        return "EncoderMockToJson"
    }
}
