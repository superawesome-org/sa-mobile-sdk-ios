//
//  AdQueryMakerMock.swift
//  Tests
//
//  Created by Gunhan Sancar on 22/04/2020.
//

@testable import SuperAwesome

class AdQueryMakerMock: AdQueryMakerType {

    static let mockQuery = AdQuery(test: true, sdkVersion: "", random: 1, bundle: "", name: "", dauid: 1,
                                   connectionType: .wifi, lang: "", device: "", position: 1, skip: 1, playbackMethod: 1,
                                   startDelay: 1, instl: 1, width: 1, height: 1   )

    var mockAdQuery: AdQuery = AdQueryMakerMock.mockQuery
    var isMakeCalled: Bool = false

    func makeAdQuery(_ request: AdRequest) -> AdQuery {
        isMakeCalled = true
        return MockFactory.makeAdQueryInstance()
    }

    func makeImpressionQuery(_ adResponse: AdResponse) -> EventQuery {
        isMakeCalled = true
        return MockFactory.makeEventQueryInstance()
    }

    func makeClickQuery(_ adResponse: AdResponse) -> EventQuery {
        isMakeCalled = true
        return MockFactory.makeEventQueryInstance()
    }

    func makeVideoClickQuery(_ adResponse: AdResponse) -> EventQuery {
        isMakeCalled = true
        return MockFactory.makeEventQueryInstance()
    }

    func makeEventQuery(_ adResponse: AdResponse, _ eventData: EventData) -> EventQuery {
        isMakeCalled = true
        return MockFactory.makeEventQueryInstance()
    }
}
