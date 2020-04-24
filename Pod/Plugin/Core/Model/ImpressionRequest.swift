//
//  ImpressionRequest.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 15/04/2020.
//

struct ImpressionRequest: Codable {
    let placement: Int
    let bundle: String
    let creative: Int
    let line_item: Int
    let ct: Int
    let sdkVersion: String
    let rnd: Int
    
    let type: EventType = .impressionDownloaded
    let no_image: Bool = true
    
    internal init(placement: Int, bundle: String, creative: Int, line_item: Int, ct: Int, sdkVersion: String, rnd: Int) {
        self.placement = placement
        self.bundle = bundle
        self.creative = creative
        self.line_item = line_item
        self.ct = ct
        self.sdkVersion = sdkVersion
        self.rnd = rnd
    }
}
