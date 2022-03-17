//
//  InterstitialAd.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 04/09/2020.
//

import SUPMoatMobileAppKit
import WebKit

private let moatServerBaseUrl = "https://z.moatads.com"
private let moatJSfile = "moatad.js"
private let moatDisplayPartnerCode = "superawesomeinappdisplay731223424656"
private let moatVideoPartnerCode = "superawesomeinappvideo467548716573"

class MoatRepository: NSObject, MoatRepositoryType {
    private let adResponse: AdResponse
    private let moatLimiting: Bool
    private let logger: LoggerType
    private let numberGenerator: NumberGeneratorType

    private var avVideoTracker: SUPMoatAVVideoTracker?
    private var webTracker: SUPMoatWebTracker?

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
        let advert = adResponse.advert
        let response = moatRand < advert.moat && moatLimiting || !moatLimiting
        logger.info("Moat allowed? \(response). moatRand: \(moatRand) ad.moat: \(advert.moat) moatLimiting: \(moatLimiting)")
        return response
    }

    func startMoatTracking(forDisplay webView: WKWebView?) -> String? {

        webTracker = SUPMoatWebTracker(webComponent: webView)
        webTracker?.trackerDelegate = self
        let result = webTracker?.startTracking() ?? false

        let advert = adResponse.advert
        var moatQuery = ""
        moatQuery += "moatClientLevel1=\(advert.advertiserId)"
        moatQuery += "&moatClientLevel2=\(advert.campaignId ?? 0)"
        moatQuery += "&moatClientLevel3=\(advert.lineItemId)"
        moatQuery += "&moatClientLevel4=\(advert.creative.id)"
        moatQuery += "&moatClientSlicer1=\(advert.app)"
        moatQuery += "&moatClientSlicer2=\(adResponse.placementId)"
        moatQuery += "&moatClientSlicer3=\(advert.publisherId)"

        let stringResult = """
        <script src="\(moatServerBaseUrl)/\(moatDisplayPartnerCode)/\(moatJSfile)?\(moatQuery)" type="text/javascript">
</script>
"""

        logger.info("Event Tracking: moat (display). SuperAwesome-Moat Started Moat web tracking with result \(result) and JS tag \(stringResult)")

        return stringResult
    }

    func stopMoatTrackingForDisplay() -> Bool {
        if let webTracker = webTracker {
            webTracker.stopTracking()
            logger.info("SuperAwesome-Moat Stopped Moat web tracking")
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

        let advert = adResponse.advert
        var adIds: [String: String] = [:]
        adIds["level1"] = "\(advert.advertiserId)"
        adIds["level2"] = "\(advert.campaignId ?? 0)"
        adIds["level3"] = "\(advert.lineItemId)"
        adIds["level4"] = "\(advert.creative.id)"
        adIds["slicer1"] = "\(advert.app)"
        adIds["slicer2"] = "\(adResponse.placementId)"
        adIds["slicer3"] = "\(advert.publisherId)"

        avVideoTracker = SUPMoatAVVideoTracker(partnerCode: moatVideoPartnerCode)
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
        logger.info("Tracker \(tracker.debugDescription) failed reason \(String(describing: reason))")
    }
}

extension MoatRepository: SUPMoatVideoTrackerDelegate {
    func tracker(_ tracker: SUPMoatBaseVideoTracker?, sentAdEventType adEventType: SUPMoatAdEventType) {
        logger.info("Tracker \(tracker.debugDescription) sending event \(String(describing: adEventType))")
    }
}
