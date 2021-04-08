//
//  ASIdentifierManagerMock.swift
//  SuperAwesome-Unit-Moya-Tests
//
//  Created by Gunhan Sancar on 04/05/2020.
//

import AdSupport
@testable import SuperAwesome

class ASIdentifierManagerMock: ASIdentifierManager {
    let mockIsAdvertisingTrackingEnabled: Bool
    let mockAdvertisingIdentifier: UUID
    
    init(mockIsAdvertisingTrackingEnabled: Bool, mockAdvertisingIdentifier: UUID) {
        self.mockIsAdvertisingTrackingEnabled = mockIsAdvertisingTrackingEnabled
        self.mockAdvertisingIdentifier = mockAdvertisingIdentifier
    }
    
    override var isAdvertisingTrackingEnabled: Bool { mockIsAdvertisingTrackingEnabled }
    override var advertisingIdentifier: UUID { mockAdvertisingIdentifier }
}
