//
//  VastParserTests.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 07/07/2020.
//
//
//import Nimble
//import SwiftyXML
//@testable import SuperAwesome
//
//class VastParserTests: XCTestCase {
//    func testUserAgentName_dataRepositryHasData_useDataRepositoryAgent() throws {
//        // Given
//        let xml = SwiftyXML(xmlFile("mock_vast_response_1.0"))
//
//        // Then
//        //expect(userAgent.name).to(equal(dataUserAgent))
//    }
//
//}

import XCTest
import Nimble
import SwiftyXMLParser
@testable import SuperAwesome

class VastParserTests: XCTestCase {
    func testUserAgentName_dataRepositryHasData_useDataRepositoryAgent() throws {
        // Given
        let xml = XML.parse(xmlFile("mock_vast_response_1.0"))
        
        if let text = xml.ResultSet.Result.Hit[1].Name.text {
            print(text) // -> Item2
        } else {
            print("Not found")
        }
                
        for linear in xml.VAST.Ad.InLine.Creatives.Creative.Linear {
            
            if let ClickThrough = linear.VideoClicks.ClickThrough.text {
                
                print("ClickThrough: \(ClickThrough)")
            }
            
//
//            for tracking in trackingEvents {
//                print("Tracking: event:\(tracking.attributes["event"] ?? "") \(tracking.text ?? "")")
//            }
//
//            for videoClick in videoClicks {
//                print("videoClick: \(videoClick.text ?? "")")
//            }
//
//            for mediaFile in mediaFiles {
//                print("mediaFile: \(mediaFile.text ?? "")")
//            }
//
//            print("Duration:\(linear.Duration.text ?? "")")
        }
        
        print("Xml:\(xml.VAST.Ad.InLine.Creatives)")
        // Then
        //expect(userAgent.name).to(equal(dataUserAgent))
    }
}
