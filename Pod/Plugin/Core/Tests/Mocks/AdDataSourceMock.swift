//
//  AdDataSourceMock.swift
//  Tests
//
//  Created by Gunhan Sancar on 24/04/2020.
//

@testable import SuperAwesome

class AdDataSourceMock: AdDataSourceType {
    var mockAdResult: Result<Ad,Error>!
    var mockEventResult: Result<Void, Error>!
    
    func getAd(placementId: Int, query: AdQuery, completion: @escaping Completion<Ad>) {
        completion(mockAdResult)
    }
    
    func impression(query: EventQuery, completion: @escaping Completion<Void>) {
        completion(mockEventResult)
    }
    
    func click(query: EventQuery, completion: @escaping Completion<Void>) {
        completion(mockEventResult)
    }
    
    func videoClick(query: EventQuery, completion: @escaping Completion<Void>) {
        completion(mockEventResult)
    }
    
    func event(query: EventQuery, completion: @escaping Completion<Void>) {
        completion(mockEventResult)
    }
}
