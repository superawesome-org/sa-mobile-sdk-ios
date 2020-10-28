//
//  HtmlFormatterMock.swift
//  SuperAwesome-Unit-Full-Tests
//
//  Created by Gunhan Sancar on 28/10/2020.
//

@testable import SuperAwesome

struct HtmlFormatterMock: HtmlFormatterType {
    let imageFormat: String
    let mediaFormat: String
    let tagFormat: String
    
    func formatImageIntoHtml(_ ad: Ad) -> String {
        imageFormat
    }
    
    func formatRichMediaIntoHtml(_ placementId: Int, _ ad: Ad) -> String {
        mediaFormat
    }
    
    func formatTagIntoHtml(_ ad: Ad) -> String {
        tagFormat
    }
}

