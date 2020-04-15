//
//  Codable+Extensions.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 15/04/2020.
//

extension Encodable {
  func toDictionary() -> [String: Any] {
    guard let data = try? JSONEncoder().encode(self) else { return [:] }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] } ?? [:]
  }
}
