//
//  AdProcessorMock.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 07/07/2020.
//

@testable import SuperAwesome

class AdProcessorMock: AdProcessorType {
    func process(_ placementId: Int, _ ad: Ad, complition: @escaping OnComplete<AdResponse>) {
        
    }
}
