//
//  NumberGenerator.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 20/04/2020.
//

protocol NumberGeneratorType {
    func nextIntForCache() -> Int
    func nextAlphanumericString(length: Int) -> String
}

class NumberGenerator: NumberGeneratorType {
    private static let cacheBoundMin: Int = 1000000
    private static let cacheBoundMax: Int = 1500000
    private static let alphanumericChars: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    func nextIntForCache() -> Int { Int.random(in: NumberGenerator.cacheBoundMin..<NumberGenerator.cacheBoundMax)}
    
    func nextAlphanumericString(length: Int) -> String {
        String((0..<length).map{ _ in NumberGenerator.alphanumericChars.randomElement()! })
    }
}
