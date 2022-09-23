//
//  SKAdNetworkManager.swift
//  SuperAwesome
//
//  Created by Mark on 29/06/2021.
//

import Foundation
import StoreKit

// All the functions should be marked with at least @available(iOS 14.5, *) for SKAdNetworkManager
protocol SKAdNetworkManager {
    @available(iOS 14.5, *)
    func startImpression(lineItemId: Int, creativeId: Int)
    @available(iOS 14.5, *)
    func endImpression()
}

@available(iOS 14.5, *)
final class SKAdNetworkManagerImpl: SKAdNetworkManager {
    private let repository: AwesomeAdsApiDataSourceType
    private var signature: String?
    private var adImpression: SKAdImpression?

    init(repository: AwesomeAdsApiDataSourceType) {
        self.repository = repository
    }

    func startImpression(lineItemId: Int, creativeId: Int) {
        repository.signature(lineItemId: lineItemId, creativeId: creativeId) { [weak self] result in
            switch result {
            case .success(let dto):
                self?.signature = dto.signature
                let adImpression = dto.skAdvertiser
                self?.adImpression = adImpression
                SKAdNetwork.startImpression(adImpression) { e in
                    print(e?.localizedDescription ?? "nil")
                }
            case .failure(let error): print(error.localizedDescription)
            }
        }
    }

    func endImpression() {
        guard let adImpression = adImpression else { return }
        SKAdNetwork.endImpression(adImpression) {[weak self] e in
            print(e?.localizedDescription ?? "nil")
            self?.adImpression = nil
        }
    }
}

extension AdvertiserSignatureDTO {
    @available(iOS 14.5, *)
    var skAdvertiser: SKAdImpression {
        let adImpression = SKAdImpression()
        adImpression.adCampaignIdentifier = campaignID as NSNumber
        adImpression.adNetworkIdentifier = adNetworkID
        adImpression.version = version
        adImpression.signature = signature
        adImpression.sourceAppStoreItemIdentifier = sourceAppID as NSNumber
        adImpression.advertisedAppStoreItemIdentifier = sourceAppID as NSNumber
        adImpression.adType = "\(fidelityType)"
        adImpression.adImpressionIdentifier = impressionID
        adImpression.timestamp = Date().timeIntervalSince1970 as NSNumber
        return adImpression
    }
}
