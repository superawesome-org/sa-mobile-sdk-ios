//
//  Robot.swift
//  SuperAwesomeExampleUITests
//
//  Created by Tom O'Rourke on 18/04/2023.
//

import XCTest
import DominantColor

extension Robot {
    
    /**
     * Method that asserts that a sampled colour of an image is the expected colour
     *
     * - Parameters:
     *  - expectedColor: The expected colour as a hex string e.g: "#FFFFFF"
     *  - sampleSize: The number of pixels to sample from the centre of the image
     *  - image: The image to test, e.g: `closeButton.screenshot().image`
     */
    func AssertExpectedColor(
        expectedColor: String,
        sampleSize: CGFloat,
        image: UIImage,
        file: StaticString = #file,
        line: UInt = #line)
    {
        
        guard sampleSize > 2 else {
            XCTFail("The sample size must be greater than 2", file: file, line: line)
            return
        }
        
        let crop = image.centreCroppedTo(
            CGSize(
                width: sampleSize,
                height: sampleSize
            )
        )
        
        let sampledColour = crop.dominantColors().first(
            where: { $0.hexString() == expectedColor }
        )
        
        XCTAssertEqual(
            expectedColor,
            sampledColour?.hexString(),
            file: file,
            line: line
        )
    }
    
    func AssertExpectedScreenshotColor(expectedColor: String) {
        AssertExpectedColor(
            expectedColor: expectedColor,
            sampleSize: 50.0,
            image: XCUIScreen.main.screenshot().image
        )
    }
}
