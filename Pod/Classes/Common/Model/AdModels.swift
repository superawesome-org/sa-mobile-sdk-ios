//
//  AdModels.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 15/04/2020.
//

public struct Ad: Codable {
    let advertiserId: Int
    let publisherId: Int
    let moat: Float
    let isFill: Bool
    let isFallback: Bool
    var campaignId: Int? = 0
    let campaignType: Int
    let isHouse: Bool
    let isVpaid: Bool?
    let safeAdApproved: Bool
    let showPadlock: Bool
    public let lineItemId: Int
    let test: Bool
    let app: Int
    let device: String
    public let creative: Creative
    let ksfRequest: String?

    enum CodingKeys: String, CodingKey {
        case advertiserId
        case publisherId
        case moat
        case isFill = "is_fill"
        case isFallback = "is_fallback"
        case campaignId = "campaign_id"
        case campaignType = "campaign_type"
        case isHouse = "is_house"
        case isVpaid = "is_vpaid"
        case safeAdApproved = "safe_ad_approved"
        case showPadlock = "show_padlock"
        case lineItemId = "line_item_id"
        case test
        case app
        case device
        case creative
        case ksfRequest
    }
}

struct AdQuery: Codable {
    let test: Bool
    let sdkVersion: String
    let random: Int
    let bundle: String
    let name: String
    let dauid: Int
    let connectionType: ConnectionType
    let lang: String
    let device: String
    let position: Int
    let skip: Int
    let playbackMethod: Int
    let startDelay: Int
    let instl: Int
    let width: Int
    let height: Int

    enum CodingKeys: String, CodingKey {
        case test
        case sdkVersion
        case random = "rnd"
        case bundle
        case name
        case dauid
        case connectionType = "ct"
        case lang
        case device
        case position = "pos"
        case skip
        case playbackMethod = "playbackmethod"
        case startDelay = "startDelay"
        case instl
        case width = "w"
        case height = "h"
    }
}

public struct AdRequest: Codable {
    let test: Bool
    let position: Position
    let skip: Skip
    let playbackMethod: Int
    let startDelay: StartDelay
    let instl: FullScreen
    let width: Int
    let height: Int

    enum CodingKeys: String, CodingKey {
        case test
        case position = "pos"
        case skip
        case playbackMethod = "playbackmethod"
        case startDelay = "startdelay"
        case instl
        case width = "w"
        case height = "h"
    }

}

class AdResponse {
    let placementId: Int
    let advert: Ad
    var html: String?
    var vast: VastAd?
    var baseUrl: String?
    var filePath: String?

    init(_ placementId: Int, _ advert: Ad) {
        self.placementId = placementId
        self.advert = advert
    }

    /// Returns the aspect ratio of the ad's creative
    func aspectRatio() -> CGFloat {
        let width = advert.creative.details.width
        let height = advert.creative.details.height
        return CGFloat(width) / CGFloat(height)
    }

    /// Returns if the type of the ad is Vpaid
    var isVpaid: Bool {
        advert.isVpaid ?? false
    }
}

extension AdRequest {
    /// The playback method
    static let PlaybackSoundOnScreen = 5

    /// Specify if the ad is in full screen or not
    enum FullScreen: Int, Codable {
        case on = 1
        case off = 0
    }

    /// Start delay cases
    @objc
    public enum StartDelay: Int, Codable {
        case postRoll = -2
        case genericMidRoll = -1
        case preRoll = 0
        case midRoll = 1
    }

    /// Specify the position of the ad
    enum Position: Int, Codable {
        case aboveTheFold = 1
        case belowTheFold = 3
        case fullScreen = 7
    }

    /// Specify if the ad can be skipped
    enum Skip: Int, Codable {
        case no = 0
        case yes = 1
    }
}

@objc
public class StartDelayHelper: NSObject {
    /// Creates `StartDelay` enum from `int` value.
    @objc
    public class func from(_ value: Int) -> AdRequest.StartDelay {
        AdRequest.StartDelay(rawValue: value) ?? Constants.defaultStartDelay
    }
}

/**
 * This enum holds all the possible callback values that an ad sends during its lifetime
 *  - adLoaded:         ad was loaded successfully and is ready
 *                      to be displayed
 *  - adEmpty           the ad server returned an empty response
 *  - adFailedToLoad:   ad was not loaded successfully and will not be
 *                      able to play
 *  - adAlreadyLoaded   ad was previously loaded in an interstitial, video or
 *                      app wall queue
 *  - adShown:          triggered once when the ad first displays
 *  - adFailedToShow:   for some reason the ad failed to show; technically
 *                      this should never happen nowadays
 *  - adClicked:        triggered every time the ad gets clicked
 *  - adEnded:          triggerd when a video ad ends
 *  - adClosed:         triggered once when the ad is closed;
 */
@objc(SAEvent)
public enum AdEvent: Int {
    case adLoaded = 0
    case adEmpty = 1
    case adFailedToLoad = 2
    case adAlreadyLoaded = 3
    case adShown = 4
    case adFailedToShow = 5
    case adClicked = 6
    case adEnded = 7
    case adClosed = 8
}

/// Callback function for completable events
public typealias AdEventCallback = (_ placementId: Int, _ event: AdEvent) -> Void

struct AdvertiserSignatureDTO: Equatable, Codable {
    let signature: String
    let campaignID: Int
    let itunesItemID: Int
    let sourceAppID: Int
    let impressionID: String
    let timestamp: String
    let version: String
    let adNetworkID: String
    let fidelityType: Int

    enum CodingKeys: String, CodingKey {
        case campaignID = "campaignId"
        case itunesItemID = "itunesItemId"
        case sourceAppID = "sourceAppId"
        case impressionID = "impressionId"
        case adNetworkID = "adNetworkId"
        case signature
        case timestamp
        case version
        case fidelityType
    }
}
