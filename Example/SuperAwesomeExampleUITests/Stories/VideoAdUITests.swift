//
//  VideoAdUITests.swift
//  SuperAwesomeExampleUITests
//
//  Created by Tom O'Rourke on 07/06/2022.
//

import XCTest
import DominantColor

class VideoAdUITests: BaseUITest {
    
    func test_closeAtEndEnabled_closeBeforeEnds_receiveOnlyAdClosedEvent() throws {
        adsListScreen(app) {
            $0.waitForView()
            
            $0.tapPlacement(withName: VideoPlacements.directVideoFlat)
            
            videoScreen(app) { screen in
                screen.waitForView()
            }
        }
    }
}

private struct VideoPlacements {
    static let directVideoFlat = "Direct Video Flat Colour"
}
