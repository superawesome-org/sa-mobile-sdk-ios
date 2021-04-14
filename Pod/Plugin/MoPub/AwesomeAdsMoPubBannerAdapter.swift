//
//  AwesomeAdsMoPubBanner.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 19/06/2020.
//

import Foundation
import MoPubSDK

@objc
public class AwesomeAdsMoPubBannerAdapter: MPInlineAdAdapter, MPThirdPartyInlineAdAdapter {
    private var bannerAd: SABannerAd? = nil
    private let errorFactory = AwesomeAdsMoPubErrorFactory()
    private let adHelper = AwesomeAdsMoPubAdHelper()
    
    public override func requestAd(with size: CGSize, adapterInfo info: [AnyHashable : Any], adMarkup: String?) {
        let extractor = AwesomeAdsMoPubAdDataExtractor(info)
        
        bannerAd = SABannerAd.init(frame: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        bannerAd?.setConfiguration(extractor.configuration.rawValue)
        bannerAd?.setTestMode(extractor.isTestEnabled)
        bannerAd?.setParentalGate(extractor.isParentalGateEnabled)
        bannerAd?.setBumperPage(extractor.isBumperPageEnabled)
        
        bannerAd?.setCallback({ [weak self] (placementId, event) in
            self?.handleEvent(event, placementId)
        })
        
        MPLogging.logEvent(MPLogEvent.adLoadAttempt(), source: "\(extractor.placementId)", from: AwesomeAdsMoPubBannerAdapter.self)
        
        bannerAd?.load(extractor.placementId)
    }
    
    private func adLoadFailed(_ placementId: Int) {
        let error = errorFactory.makeError(message: "Ad empty or failed to load", placementId: placementId, errorCode: MOPUBErrorAdapterInvalid)
        
        let event = MPLogEvent.adLoadFailed(forAdapter: NSStringFromClass(AwesomeAdsMoPubBannerAdapter.self), error: error)
        
        MPLogging.logEvent(event, source: "\(placementId)", from: AwesomeAdsMoPubBannerAdapter.self)

        delegate?.inlineAdAdapter(self, didFailToLoadAdWithError: error)
    }
    
    private func handleEvent(_ event: SAEvent, _ placementId: Int) {
        switch event {
        case .adLoaded:
            if adHelper.isEmpty(self.bannerAd?.getAd()) {
                adLoadFailed(placementId)
            } else {
                let adapter = "\(AwesomeAdsMoPubBannerAdapter.self)"
                let source = "\(placementId)"
                let from = AwesomeAdsMoPubBannerAdapter.self
                
                MPLogging.logEvent(MPLogEvent.adLoadSuccess(forAdapter: adapter), source: source, from: from)
                MPLogging.logEvent(MPLogEvent.adShowAttempt(forAdapter: adapter), source: source, from: from)
                MPLogging.logEvent(MPLogEvent.adShowSuccess(forAdapter: adapter), source: source, from: from)
                
                delegate?.inlineAdAdapter(self, didLoadAdWithAdView: self.bannerAd)
                self.bannerAd?.play()
            }
        case .adEmpty, .adFailedToLoad, .adFailedToShow:
            adLoadFailed(placementId)
        case .adAlreadyLoaded:
            do {}
        case .adShown:
            delegate?.inlineAdAdapterWillBeginUserAction(self)
        case .adClicked:
            delegate?.inlineAdAdapterDidTrackClick(self)
        case .adEnded:
            do {}
        case .adClosed:
            delegate?.inlineAdAdapterDidEndUserAction(self)
        }
    }
    
    deinit {
        bannerAd?.close()
        bannerAd?.setCallback(nil)
    }
}
