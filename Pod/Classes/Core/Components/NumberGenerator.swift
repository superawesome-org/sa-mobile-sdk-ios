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
    func nextIntForCache() -> Int { Int.random(in: 1000000..<1500000)}
}
