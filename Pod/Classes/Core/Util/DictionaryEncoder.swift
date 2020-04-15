//
//  DictionaryEncoder.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 15/04/2020.
//

class DictionaryEncoder {
    private let jsonEncoder = JSONEncoder()

    func encode<T>(_ value: T) throws -> Any where T: Encodable {
        let encodable = try jsonEncoder.encode(value)
        return try JSONSerialization.jsonObject(with: encodable, options: .allowFragments)
    }
}

extension Encodable {
  var asDictionary: [String: Any] {
    guard let data = try? JSONEncoder().encode(self) else { return [:] }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] } ?? [:]
  }
}
