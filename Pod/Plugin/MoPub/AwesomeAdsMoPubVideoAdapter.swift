//
//  AwesomeAdsMoPubVideo.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 19/06/2020.
//

import Foundation
import MoPub

@objc
public class AwesomeAdsMoPubVideoAdapter: MPFullscreenAdAdapter, MPThirdPartyFullscreenAdAdapter {
    private var placementId: Int = 0
    private let errorFactory = AwesomeAdsMoPubErrorFactory()
    private let adHelper = AwesomeAdsMoPubAdHelper()

    public override func requestAd(withAdapterInfo info: [AnyHashable: Any], adMarkup: String?) {
        let extractor = AwesomeAdsMoPubAdDataExtractor(info)
        placementId = extractor.placementId

        VideoAd.setConfiguration(extractor.configuration)
        VideoAd.setTestMode(extractor.isTestEnabled)
        VideoAd.setParentalGate(extractor.isParentalGateEnabled)
        VideoAd.setBumperPage(extractor.isBumperPageEnabled)
        VideoAd.setOriantation(extractor.orientation)
        VideoAd.setCloseButton(extractor.shouldShowCloseButton)
        VideoAd.setCloseAtEnd(extractor.shouldAutomaticallyCloseAtEnd)
        VideoAd.setSmallClick(extractor.shouldShowSmallClickButton)
        VideoAd.setPlaybackMode(extractor.playbackMode)

        VideoAd.setCallback { [weak self] (placementId, event) in
            self?.handleEvent(event, placementId)
        }

        VideoAd.load(withPlacementId: placementId)

        MPLogging.logEvent(MPLogEvent.adLoadAttempt(), source: "\(extractor.placementId)", from: AwesomeAdsMoPubVideoAdapter.self)
    }

    private func adLoadFailed( _ placementId: Int) {
        let error = errorFactory.makeError(message: "Ad empty or failed to load", placementId: placementId, errorCode: MOPUBErrorAdapterInvalid)

        let event = MPLogEvent.adLoadFailed(forAdapter: NSStringFromClass(AwesomeAdsMoPubVideoAdapter.self), error: error)

        MPLogging.logEvent(event, source: "\(placementId)", from: AwesomeAdsMoPubVideoAdapter.self)

        delegate?.fullscreenAdAdapter(self, didFailToLoadAdWithError: error)
    }

    private func handleEvent(_ event: SAEvent, _ placementId: Int) {
        switch event {
        case .adLoaded:
            if VideoAd.getAd(placementId: placementId) == nil {
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
            delegate?.fullscreenAdAdapterAdWillAppear(self)
            delegate?.fullscreenAdAdapterAdDidAppear(self)
        case .adClicked:
            delegate?.fullscreenAdAdapterDidTrackClick(self)
        case .adEnded:
            do {}
        case .adClosed:
            delegate?.fullscreenAdAdapterAdWillDisappear(self)
            delegate?.fullscreenAdAdapterAdDidDisappear(self)
        }
    }

    public override var isRewardExpected: Bool { false }

    public override var hasAdAvailable: Bool {
        get { VideoAd.hasAdAvailable(placementId: placementId) }
        set { }
    }

    public override func presentAd(from viewController: UIViewController) {
        if hasAdAvailable {
            VideoAd.play(withPlacementId: placementId, fromVc: viewController)
            delegate?.fullscreenAdAdapterAdWillAppear(self)
        }
    }
}
