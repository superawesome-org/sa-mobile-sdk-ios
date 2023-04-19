//
//  Robot.swift
//  SuperAwesomeExampleUITests
//
//  Created by Tom O'Rourke on 18/04/2023.
//

import Foundation
import XCTest
import DominantColor

extension Robot {
    
    func AssertExpectedColor(expectedColor: String, sampleSize: CGFloat, image: UIImage) {
        
        let crop = image.centreCroppedTo(CGSize(width: sampleSize, height: sampleSize))
        let sampledColour = crop.dominantColors().first(where: { $0.hexString() == expectedColor })
        
        XCTAssertEqual(expectedColor, sampledColour?.hexString())
    }
    
    func AssertExpectedScreenshotColor(expectedColor: String) {
        AssertExpectedColor(
            expectedColor: expectedColor,
            sampleSize: 50.0,
            image: XCUIScreen.main.screenshot().image
        )
    }
}
