//
//  AdProcessorMock.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 07/07/2020.
//

@testable import SuperAwesome

class AdProcessorMock: AdProcessorType {
    func process(_ placementId: Int, _ ad: Ad, _ requestOptions: [String : String]?, completion: @escaping OnComplete<AdResponse>) {
        completion(AdResponse(placementId, ad, requestOptions))
    }
}
