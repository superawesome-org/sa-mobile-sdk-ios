//
//  AdQueryMakerMock.swift
//  Tests
//
//  Created by Gunhan Sancar on 22/04/2020.
//

@testable import SuperAwesome

class AdQueryMakerMock: AdQueryMakerType {

    static let mockQuery = QueryBundle(parameters: AdQuery(test: true,
                                                           sdkVersion: "",
                                                           random: 1,
                                                           bundle: "",
                                                           name: "",
                                                           dauid: 1,
                                                           connectionType: .wifi,
                                                           lang: "",
                                                           device: "",
                                                           position: 1,
                                                           skip: 1,
                                                           playbackMethod: 1,
                                                           startDelay: 1,
                                                           instl: 1,
                                                           width: 1,
                                                           height: 1), options: nil)

    var mockAdQuery: QueryBundle = AdQueryMakerMock.mockQuery
    var isMakeCalled: Bool = false

    func makeAdQuery(_ request: AdRequest) -> QueryBundle {
        isMakeCalled = true
        return MockFactory.makeAdQueryInstance()
    }

    func makeImpressionQuery(_ adResponse: AdResponse) -> QueryBundle {
        isMakeCalled = true
        return MockFactory.makeEventQueryInstance()
    }

    func makeClickQuery(_ adResponse: AdResponse) -> QueryBundle {
        isMakeCalled = true
        return MockFactory.makeEventQueryInstance()
    }

    func makeVideoClickQuery(_ adResponse: AdResponse) -> QueryBundle {
        isMakeCalled = true
        return MockFactory.makeEventQueryInstance()
    }

    func makeEventQuery(_ adResponse: AdResponse, _ eventData: EventData) -> QueryBundle {
        isMakeCalled = true
        return MockFactory.makeEventQueryInstance()
    }
}
