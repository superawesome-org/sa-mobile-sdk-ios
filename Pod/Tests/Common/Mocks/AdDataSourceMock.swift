//
//  AdDataSourceMock.swift
//  Tests
//
//  Created by Gunhan Sancar on 24/04/2020.
//

@testable import SuperAwesome

class AdDataSourceMock: AwesomeAdsApiDataSourceType {

    var mockAdResult: Result<Ad, Error>!
    var mockEventResult: Result<Void, Error>!

    func getAd(placementId: Int, query: AdQuery, completion: @escaping OnResult<Ad>) {
        completion(mockAdResult)
    }
    func event(query: EventQuery, completion: OnResult<Void>?) {
        completion?(mockEventResult)
    }

    func impression(query: EventQuery, completion: OnResult<Void>?) {
        completion?(mockEventResult)
    }

    func click(query: EventQuery, completion: OnResult<Void>?) {
        completion?(mockEventResult)
    }

    func videoClick(query: EventQuery, completion: OnResult<Void>?) {
        completion?(mockEventResult)
    }
}
