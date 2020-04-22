//
//  String+Extensions.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 08/04/2020.
//

extension String {
    var urlEscaped: String { addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! }
    var utf8Encoded: Data { data(using: .utf8)! }
}
