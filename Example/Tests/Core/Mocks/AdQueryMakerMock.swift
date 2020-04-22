//
//  AdQueryMakerMock.swift
//  Tests
//
//  Created by Gunhan Sancar on 22/04/2020.
//  Copyright © 2020 Gabriel Coman. All rights reserved.
//

@testable import SuperAwesome

class AdQueryMakerMock: AdQueryMakerType {
    static let mockQuery = AdQuery(test: true, sdkVersion: "", rnd: 1, bundle: "", name: "", dauid: 1, ct: .wifi, lang: "", device: "", pos: 1, skip: 1, playbackmethod: 1, startdelay: 1, instl: 1, w: 1, h: 1   )
    
    var mockAdQuery:AdQuery = AdQueryMakerMock.mockQuery
    var isMakeCalled: Bool = false
    
    func make(_ request: AdRequest) -> AdQuery {
        self.isMakeCalled = true
        return mockAdQuery
    }
}
