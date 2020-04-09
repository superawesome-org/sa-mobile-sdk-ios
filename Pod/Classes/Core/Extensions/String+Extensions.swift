//
//  String+Extensions.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 08/04/2020.
//

extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
