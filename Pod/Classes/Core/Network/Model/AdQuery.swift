//
//  AdQuery.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 17/04/2020.
//

struct AdQuery: Codable {
    let test: Bool
    let sdkVersion: String
    let rnd: Int
    let bundle: String
    let name: String
    let dauid: Int
    let ct: ConnectionType
    let lang: String
    let device: String
    let pos: Int
    let skip: Int
    let playbackmethod: Int
    let startdelay: Int
    let instl: Int
    let w: Int
    let h: Int
}

