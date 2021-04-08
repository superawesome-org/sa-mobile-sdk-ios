//
//  String+Extensions.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 08/04/2020.
//

import Foundation
import CommonCrypto

extension String {
    var urlEscaped: String? { addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) }
    var utf8Encoded: Data? { data(using: .utf8) }
    var toInt: Int? { Int(self) }
    
    var toMD5: String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)

        if let data = self.data(using: String.Encoding.utf8) {
            _ = data.withUnsafeBytes { bytes in
                CC_MD5(bytes, CC_LONG(data.count), &digest)
            }
        }

        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
}
