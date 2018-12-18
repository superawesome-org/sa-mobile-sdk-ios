//
//  SAVideoAd2.swift
//  SuperAwesome
//
//  Created by Gabriel Coman on 17/12/2018.
//

import UIKit
import SAModelSpace
import SASession
import SAAdLoader

enum AdState {
    case none
    case loading
    case hasAd(ad: SAAd)
}

@objc(SAVideoAd2) public class VideoAd: NSObject {
    
    static var isTestingEnabled: Bool = Bool(truncating: NSNumber(value: SA_DEFAULT_TESTMODE))
    static var isParentalGateEnabled: Bool = Bool(truncating: NSNumber(value: SA_DEFAULT_PARENTALGATE))
    static var isBumperPageEnabled: Bool = Bool(truncating: NSNumber(value: SA_DEFAULT_BUMPERPAGE))
    static var shouldAutomaticallyCloseAtEnd: Bool = Bool(truncating: NSNumber(value: SA_DEFAULT_CLOSEATEND))
    static var shouldShowCloseButton: Bool = Bool(truncating: NSNumber(value: SA_DEFAULT_CLOSEBUTTON))
    
    static var shouldShowSmallClickButton: Bool = Bool(truncating: NSNumber(value: SA_DEFAULT_SMALLCLICK))
    static var orientation: SAOrientation = SAOrientation(rawValue: Int(SA_DEFAULT_ORIENTATION))!
    static var configuration: SAConfiguration = SAConfiguration(rawValue: Int(SA_DEFAULT_CONFIGURATION))!
    static var isMoatLimitingEnabled: Bool = Bool(truncating: NSNumber(value: SA_DEFAULT_MOAT_LIMITING_STATE))
    static var playback: SARTBStartDelay = SARTBStartDelay(rawValue: Int(SA_DEFAULT_PLAYBACK_MODE))!
    
    private static var ads = Dictionary<Int, AdState>()
    
    private static var callback: sacallback? = nil
    
    private static let session: SASession = SASession()
    
    private static let events: VideoEvents = VideoEvents()
    static let control: MediaControl = AwesomeMediaControl()
    
    @objc(load:)
    public static func load(placementId: Int) {
        // trying to init the SDK very late
        AwesomeAds.initSDK(false)
        
        let adState = ads[placementId] ?? .none
        
        switch adState {
        case .none:
            ads[placementId] = .loading
            
            session.setTestMode(isTestingEnabled)
            session.setConfiguration(configuration)
            session.setVersion(SAVersion.getSdkVersion())
            session.setPos(SARTBPosition.POS_FULLSCREEN)
            session.setPlaybackMethod(SARTBPlaybackMethod.PB_WITH_SOUND_ON_SCREEN)
            session.setInstl(SARTBInstl.IN_FULLSCREEN)
            session.setSkip(shouldShowCloseButton ? SARTBSkip.SK_SKIP : SARTBSkip.SK_NO_SKIP)
            session.setStartDelay(playback)
            let size = UIScreen.main.bounds.size
            session.setWidth(Int(size.width))
            session.setHeight(Int(size.height))
            
            let loader = SALoader()
            loader.loadAd(placementId, withSession: session) { (response: SAResponse?) in
                
                guard let response = response, response.status == 200 else {
                    ads[placementId] = .none
                    callback?(placementId, SAEvent.adFailedToLoad)
                    return
                }
                
                guard let ad = response.ads.firstObject as? SAAd,
                        response.isValid(),
                        ad.creative.details.media.isDownloaded else {
                            ads[placementId] = .none
                            callback?(placementId, SAEvent.adEmpty)
                            return
                }
                
                events.reset(placementId: placementId, ad: ad, session: session, isMoatLimitingEnabled: isMoatLimitingEnabled)
                control.add(delegate: events)
            
                ads[placementId] = .hasAd(ad: ad)
                callback?(placementId, SAEvent.adLoaded)
            }
            
        case .loading:
            break
        case .hasAd:
            callback?(placementId, SAEvent.adAlreadyLoaded)
        }
    }
    
    @objc(play:fromVC:)
    public static func play(withPlacementId placementId: Int,
                            fromViewController viewController: UIViewController) {
        
        let adState = ads[placementId] ?? .none
        
        switch adState {
        case .hasAd(let ad):
            let adVc = VideoViewController()
            adVc.ad = ad
            viewController.present(adVc, animated: true)
            ads[placementId] = .none
            break
        default:
            callback?(placementId, SAEvent.adFailedToShow)
            break
        }
    }
    
    @objc(hasAdAvailable:)
    public static func hasAdAvailable(placementId: Int) -> Bool {
        let adState = ads[placementId] ?? .none
        switch adState {
        case .hasAd: return true
        default: return false
        }
    }
    
    @objc(getAd:)
    public static func getAd(placementId: Int) -> SAAd? {
        let adState = ads[placementId] ?? .none
        switch adState {
        case .hasAd(let ad): return ad
        default: return nil
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // setters
    ////////////////////////////////////////////////////////////////////////////

    @objc(setCallback:)
    public static func setCallback(_ callback: @escaping sacallback) {
        self.callback = callback
        events.setCallback(callback)
    }

    @objc(setTestMode:)
    public static func setTestMode(_ testMode: Bool) {
        self.isTestingEnabled = testMode
    }

    @objc(enableTestMode)
    public static func enableTestMode() {
        setTestMode(true)
    }

    @objc(disableTestMode)
    public static func disableTestMode() {
        setTestMode(false)
    }

    @objc(setParentalGate:)
    public static func setParentalGate(_ parentalGate: Bool) {
        self.isParentalGateEnabled = parentalGate
    }

    @objc(enableParentalGate)
    public static func enableParentalGate() {
        setParentalGate(true)
    }

    @objc(disableParentalGate)
    public static func disableParentalGate() {
        setParentalGate(false)
    }

    @objc(setBumperPage:)
    public static func setBumperPage(_ bumperPage: Bool) {
        self.isBumperPageEnabled = bumperPage
    }

    @objc(enableBumperPage)
    public static func enableBumperPage() {
        setBumperPage(true)
    }

    @objc(disableBumperPage)
    public static func disableBumperPage() {
        setBumperPage(false)
    }

    @objc(setConfiguration:)
    public static func setConfiguration(_ config: SAConfiguration) {
        self.configuration = config
    }

    @objc(setConfigurationProduction)
    public static func setConfigurationProduction() {
        setConfiguration(SAConfiguration.PRODUCTION)
    }

    @objc(setConfigurationStaging)
    public static func setConfigurationStaging() {
        setConfiguration(SAConfiguration.STAGING)
    }

    static func setOriantation(_ orientation: SAOrientation) {
        self.orientation = orientation
    }

    @objc(setOrientationAny)
    public static func setOrientationAny() {
        setOriantation(SAOrientation.ANY)
    }

    @objc(setOrientationPortrait)
    public static func setOrientationPortrait() {
        setOriantation(SAOrientation.PORTRAIT)
    }

    @objc(setOrientationLandscape)
    public static func setOrientationLandscape() {
        setOriantation(SAOrientation.LANDSCAPE)
    }

    @objc(setCloseButton:)
    public static func setCloseButton(_ close: Bool) {
        self.shouldShowCloseButton = close
    }

    @objc(enableCloseButton)
    public static func enableCloseButton() {
        setCloseButton(true)
    }

    @objc(disableCloseButton)
    public static func disableCloseButton() {
        setCloseButton(false)
    }

    @objc(setSmallClick:)
    public static func setSmallClick(_ smallClick: Bool) {
        self.shouldShowSmallClickButton = smallClick
    }

    @objc(enableSmallClickButton)
    public static func enableSmallClickButton() {
        setSmallClick(true)
    }

    @objc(disableSmallClickButton)
    public static func disableSmallClickButton() {
        setSmallClick(false)
    }

    @objc(setCloseAtEnd:)
    public static func setCloseAtEnd(_ close: Bool) {
        self.shouldAutomaticallyCloseAtEnd = close
    }

    @objc(enableCloseAtEnd)
    public static func enableCloseAtEnd() {
        setCloseAtEnd(true)
    }

    @objc(disableCloseAtEnd)
    public static func disableCloseAtEnd() {
        setCloseAtEnd(false)
    }

    @objc(setPlaybackMode:)
    public static func setPlaybackMode(_ delay: SARTBStartDelay) {
        self.playback = delay
    }
}
