//
//  String+Extensions.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 08/04/2020.
//

import Foundation
import CommonCrypto

extension String {

    /// Returns the Int value of a string
    var toInt: Int? { Int(self) }

    /// Returns an MD5 has of the current string
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

    /// Returns the base url formed from a full url
    var baseUrl: String {
        let url = URL(string: self)
        return "\(url?.scheme ?? "")://\(url?.host ?? "")"
    }

    /// Returns the extension name or nil
    var fileExtension: String? {
        let parts = components(separatedBy: ".")
        return parts.count > 1 ? parts.last : nil
    }
}

extension StringProtocol {
    func indexUpperBound<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }

    /// Returns a string which is substring of the given string starting at the end of `from` parameter
    func suffix(from: String) -> String? {
        if let index = indexUpperBound(of: from) {
            return String(suffix(from: index))
        }
        return nil
    }
}
