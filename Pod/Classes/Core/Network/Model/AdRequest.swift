//
//  AdRequest.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 15/04/2020.
//

struct AdRequest: Codable {
    let environment: Environment
    let test: Bool
    let dauid: Int
    let ct: Int
    let pos: Int
    let skip: Int
    let playbackmethod: Int
    let startdelay: Int
    let instl: Int
    let w: Int
    let h: Int
}
