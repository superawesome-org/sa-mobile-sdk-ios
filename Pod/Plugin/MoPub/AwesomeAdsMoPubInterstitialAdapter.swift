//
//  AwesomeAdsMoPubInterstitial.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 19/06/2020.
//

import Foundation
import MoPub

@objc
public class AwesomeAdsMoPubInterstitialAdapter: MPFullscreenAdAdapter, MPThirdPartyFullscreenAdAdapter {
    private var placementId: Int = 0
    private let errorFactory = AwesomeAdsMoPubErrorFactory()
    private let adHelper = AwesomeAdsMoPubAdHelper()

    public override func requestAd(withAdapterInfo info: [AnyHashable: Any], adMarkup: String?) {
        let extractor = AwesomeAdsMoPubAdDataExtractor(info)
        placementId = extractor.placementId

        SAInterstitialAd.setConfiguration(extractor.configuration.rawValue)
        SAInterstitialAd.setTestMode(extractor.isTestEnabled)
        SAInterstitialAd.setParentalGate(extractor.isParentalGateEnabled)
        SAInterstitialAd.setBumperPage(extractor.isBumperPageEnabled)
        SAInterstitialAd.setOrientation(extractor.orientation)

        SAInterstitialAd.setCallback { [weak self] (placementId, event) in
            self?.handleEvent(event, placementId)
        }

        SAInterstitialAd.load(placementId)

        MPLogging.logEvent(MPLogEvent.adLoadAttempt(), source: "\(extractor.placementId)", from: AwesomeAdsMoPubInterstitialAdapter.self)
    }

    private func adLoadFailed( _ placementId: Int) {
        let error = errorFactory.makeError(message: "Ad empty or failed to load", placementId: placementId, errorCode: MOPUBErrorAdapterInvalid)

        let event = MPLogEvent.adLoadFailed(forAdapter: NSStringFromClass(AwesomeAdsMoPubInterstitialAdapter.self), error: error)

        MPLogging.logEvent(event, source: "\(placementId)", from: AwesomeAdsMoPubInterstitialAdapter.self)

        delegate?.fullscreenAdAdapter(self, didFailToLoadAdWithError: error)
    }

    private func handleEvent(_ event: SAEvent, _ placementId: Int) {
        switch event {
        case .adLoaded:
            if adHelper.isEmpty(SAInterstitialAd.getAd(placementId)) {
                adLoadFailed(placementId)
            } else {
                delegate?.fullscreenAdAdapterDidLoadAd(self)
            }
        case .adEmpty, .adFailedToLoad:
            adLoadFailed(placementId)
        case .adFailedToShow:
            let error = errorFactory.makeError(message: "Ad empty or failed to show", placementId: placementId, errorCode: MOPUBErrorAdapterInvalid)

            delegate?.fullscreenAdAdapter(self, didFailToShowAdWithError: error)
        case .adAlreadyLoaded:
            do {}
        case .adShown:
            delegate?.fullscreenAdAdapterAdDidAppear(self)
        case .adClicked:
            delegate?.fullscreenAdAdapterDidTrackClick(self)
        case .adEnded:
            do {}
        case .adClosed:
            delegate?.fullscreenAdAdapterAdDidDisappear(self)
        }
    }

    public override var isRewardExpected: Bool { false }

    public override var hasAdAvailable: Bool {
        get { SAInterstitialAd.hasAdAvailable(placementId) }
        set { }
    }

    public override func presentAd(from viewController: UIViewController) {
        SAInterstitialAd.play(placementId, fromVC: viewController)
        self.delegate?.fullscreenAdAdapterAdWillAppear(self)
    }

    deinit {
        SAInterstitialAd.setCallback(nil)
    }
}
