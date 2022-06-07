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

    func getAd(placementId: Int, query: QueryBundle, completion: @escaping OnResult<Ad>) {
        completion(mockAdResult)
    }

    func getAd(placementId: Int,
               lineItemId: Int,
               creativeId: Int,
               query: QueryBundle,
               completion: @escaping OnResult<Ad>) {
        completion(mockAdResult)
    }

    func event(query: QueryBundle, completion: OnResult<Void>?) {
        completion?(mockEventResult)
    }

    func impression(query: QueryBundle, completion: OnResult<Void>?) {
        completion?(mockEventResult)
    }

    func click(query: QueryBundle, completion: OnResult<Void>?) {
        completion?(mockEventResult)
    }

    func videoClick(query: QueryBundle, completion: OnResult<Void>?) {
        completion?(mockEventResult)
    }

    func signature(lineItemId: Int, creativeId: Int, completion: @escaping OnResult<AdvertiserSignatureDTO>) {

    }

    func get(endPoint: String, params: [String: String], completion: OnResult<Void>?) {
        completion?(mockEventResult)
    }
}
