//
//  AdModels.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 15/04/2020.
//

struct Ad: Codable {
    let advertiserId: Int
    let publisherId: Int
    let moat: Float
    let is_fill: Bool
    let is_fallback: Bool
    var campaign_id: Int? = 0
    let campaign_type: Int
    let is_house: Bool
    let safe_ad_approved: Bool
    let show_padlock: Bool
    let line_item_id: Int
    let test: Bool
    let app: Int
    let device: String
    let creative: Creative
}

struct AdQuery: Codable {
    let test: Bool
    let sdkVersion: String
    let rnd: Int
    let bundle: String
    let name: String
    let dauid: Int
    let ct: ConnectionType
    let lang: String
    let device: String
    let pos: Int
    let skip: Int
    let playbackmethod: Int
    let startdelay: Int
    let instl: Int
    let w: Int
    let h: Int
}

public struct AdRequest: Codable {
    let test: Bool
    let pos: Position
    let skip: Skip
    let playbackmethod: Int
    let startdelay: StartDelay
    let instl: FullScreen
    let w: Int
    let h: Int
}

class AdResponse {
    let placementId: Int
    let ad: Ad
    var html: String?
    var vast: VastAd?
    var baseUrl: String?
    var filePath: String?
    
    init(_ placementId: Int, _ ad: Ad) {
        self.placementId = placementId
        self.ad = ad
    }
    
    /// Returns the aspect ratio of the ad's creative
    func aspectRatio() -> CGFloat {
        let width = ad.creative.details.width
        let height = ad.creative.details.height
        return CGFloat(width) / CGFloat(height)
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
public enum AdEvent : Int {
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
