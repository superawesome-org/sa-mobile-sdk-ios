//
//  AdDataSourceMock.swift
//  Tests
//
//  Created by Gunhan Sancar on 24/04/2020.
//

@testable import SuperAwesome

class AdDataSourceMock: AdDataSourceType {
    var mockResult: Result<Ad,Error>
    
    init(_ mockResult: Result<Ad,Error>) {
        self.mockResult = mockResult
    }
    
    func getAd(placementId: Int, request: AdRequest, completion: @escaping Completion<Ad>) {
        completion(mockResult)
    }
}
