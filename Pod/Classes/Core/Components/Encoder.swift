//
//  Encoder.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 21/04/2020.
//

protocol EncoderType {
    func encodeUri(_ string: String?) -> String
}

class Encoder: EncoderType {
    private let escapedSet = CharacterSet(charactersIn: "!*'\"();:@&=+$,/?%#[]% ").inverted
    
    func encodeUri(_ string: String?) -> String {
        guard let string = string, string.count > 0 else { return "" }
        return string.addingPercentEncoding( withAllowedCharacters: escapedSet ) ?? ""
    }
}
