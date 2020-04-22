//
//  NumberGenerator.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 20/04/2020.
//

protocol NumberGeneratorType {
    func nextIntForCache() -> Int
}

class NumberGenerator: NumberGeneratorType {
    private static let cacheBoundMin: Int = 1000000
    private static let cacheBoundMax: Int = 1500000
    
    func nextIntForCache() -> Int { Int.random(in: NumberGenerator.cacheBoundMin..<NumberGenerator.cacheBoundMax)}
}
