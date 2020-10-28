//
//  InterstitialAd.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 04/09/2020.
//

import SUPMoatMobileAppKit
import WebKit

private let MOAT_SERVER = "https://z.moatads.com"
private let MOAT_URL = "moatad.js"
private let MOAT_DISPLAY_PARTNER_CODE = "superawesomeinappdisplay731223424656"
private let MOAT_VIDEO_PARTNER_CODE = "superawesomeinappvideo467548716573"

class MoatRepository: NSObject, MoatRepositoryType {
    private let adResponse: AdResponse
    private let moatLimiting: Bool
    private let logger: LoggerType
    private let numberGenerator: NumberGeneratorType
    
    private var avVideoTracker: SUPMoatAVVideoTracker? = nil
    private var webTracker: SUPMoatWebTracker? = nil
    
    init(adResponse: AdResponse, moatLimiting: Bool, logger: LoggerType, numberGenerator: NumberGeneratorType) {
        self.adResponse = adResponse
        self.moatLimiting = moatLimiting
        self.logger = logger
        self.numberGenerator = numberGenerator
    }
    
    /// Method that determines is Moat can be triggered at this point
    ///
    /// - Returns: true or false
    func isMoatAllowed() -> Bool {
        let moatRand = numberGenerator.nextFloatForMoat()
        let ad = adResponse.ad
        let response = moatRand < ad.moat && moatLimiting || !moatLimiting
        logger.info("Moat allowed? \(response). moatRand: \(moatRand) ad.moat: \(ad.moat) moatLimiting: \(moatLimiting)")
        return response
    }
    
    func startMoatTracking(forDisplay webView: WKWebView?) -> String? {
        
        webTracker = SUPMoatWebTracker(webComponent: webView)
        webTracker?.trackerDelegate = self
        let result = webTracker?.startTracking() ?? false
        
        let ad = adResponse.ad
        var moatQuery = ""
        moatQuery += "moatClientLevel1=\(ad.advertiserId)"
        moatQuery += "&moatClientLevel2=\(ad.campaign_id)"
        moatQuery += "&moatClientLevel3=\(ad.line_item_id)"
        moatQuery += "&moatClientLevel4=\(ad.creative.id)"
        moatQuery += "&moatClientSlicer1=\(ad.app)"
        moatQuery += "&moatClientSlicer2=\(adResponse.placementId)"
        moatQuery += "&moatClientSlicer3=\(ad.publisherId)"
        
        let stringResult = "<script src=\"\(MOAT_SERVER)/\(MOAT_DISPLAY_PARTNER_CODE)/\(MOAT_URL)?\(moatQuery)\" type=\"text/javascript\"></script>"
        
        logger.info("SuperAwesome-Moat Started Moat web stracking with result \(result) and JS tag \(stringResult)")
        
        return stringResult
    }
    
    func stopMoatTrackingForDisplay() -> Bool {
        if let webTracker = webTracker {
            webTracker.stopTracking()
            logger.info("SuperAwesome-Moat Stoped Moat web tracking")
            return true
        } else {
            logger.info("SuperAwesome-Moat Failed to stop Moat web tracking because webTracker is null")
            return false
        }
    }
    
    func startMoatTracking(forVideoPlayer player: AVPlayer?, with layer: AVPlayerLayer?, andView view: UIView?) -> Bool {
        guard let player = player, let layer = layer else {
            logger.info("Moat tracking could not be started because player and/or layer is nil")
            return false
        }
        
        let ad = adResponse.ad
        var adIds: [String: String] = [:]
        adIds["level1"] = "\(ad.advertiserId)"
        adIds["level2"] = "\(ad.campaign_id)"
        adIds["level3"] = "\(ad.line_item_id)"
        adIds["level4"] = "\(ad.creative.id)"
        adIds["slicer1"] = "\(ad.app)"
        adIds["slicer2"] = "\(adResponse.placementId)"
        adIds["slicer3"] = "\(ad.publisherId)"
        
        avVideoTracker = SUPMoatAVVideoTracker(partnerCode: MOAT_VIDEO_PARTNER_CODE)
        avVideoTracker?.trackerDelegate = self
        avVideoTracker?.videoTrackerDelegate = self
        let result = avVideoTracker?.trackVideoAd(adIds, player: player, layer: layer) ?? false
        logger.info("SuperAwesome-Moat Started Moat video tracking with result \(result)")
        return result
    }
    
    func stopMoatTrackingForVideoPlayer() -> Bool {
        if let avVideoTracker = avVideoTracker {
            avVideoTracker.stopTracking()
            logger.info("SuperAwesome-Moat Stoped Moat video tracking")
            return true
        } else {
            logger.info("SuperAwesome-Moat Failed to stop Moat video tracking because videoTracker is null")
            return false
        }
    }
}

extension MoatRepository: SUPMoatTrackerDelegate {
    func trackerStartedTracking(_ tracker: SUPMoatBaseTracker?) {
        logger.info("Tracker \(tracker.debugDescription) started tracking")
    }
    
    func trackerStoppedTracking(_ tracker: SUPMoatBaseTracker?) {
        logger.info("Tracker \(tracker.debugDescription) stopped tracking")
    }
    
    func tracker(_ tracker: SUPMoatBaseTracker?, failedToStartTracking type: SUPMoatStartFailureType, reason: String?) {
        logger.info("Tracker \(tracker.debugDescription) failed to start tracking because \(String(describing: reason))")
    }
}

extension MoatRepository: SUPMoatVideoTrackerDelegate {
    func tracker(_ tracker: SUPMoatBaseVideoTracker?, sentAdEventType adEventType: SUPMoatAdEventType) {
        logger.info("Tracker \(tracker.debugDescription) sending event \(String(describing: adEventType))")
    }
}
