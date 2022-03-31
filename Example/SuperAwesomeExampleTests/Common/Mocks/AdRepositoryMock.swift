//
//  AdRepositoryMock.swift
//  SuperAwesomeExampleTests
//
//  Created by Gunhan Sancar on 30/03/2022.
//

@testable import SuperAwesome

class AdRepositoryMock: AdRepositoryType {
    var response: Result<AdResponse, Error>  = Result.success(MockFactory.makeAdResponse())

    func getAd(placementId: Int, request: AdRequest, completion: @escaping OnResult<AdResponse>) {
        completion(response)
    }
}
