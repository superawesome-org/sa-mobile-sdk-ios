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
import SAEvents

enum AdState {
    case none
    case loading
    case hasAd(ad: SAAd)
}

@objc(SAVideoAd2) public class VideoAd: NSObject, ClickVideoEventsDelegate, TimedVideoEventsDelegate {
    
    static let shared = VideoAd()
    
    var isTestingEnabled: Bool = Bool(truncating: NSNumber(value: SA_DEFAULT_TESTMODE))
    var isParentalGateEnabled: Bool = Bool(truncating: NSNumber(value: SA_DEFAULT_PARENTALGATE))
    var isBumperPageEnabled: Bool = Bool(truncating: NSNumber(value: SA_DEFAULT_BUMPERPAGE))
    var shouldAutomaticallyCloseAtEnd: Bool = Bool(truncating: NSNumber(value: SA_DEFAULT_CLOSEATEND))
    var shouldShowCloseButton: Bool = Bool(truncating: NSNumber(value: SA_DEFAULT_CLOSEBUTTON))
    
    var shouldShowSmallClickButton: Bool = Bool(truncating: NSNumber(value: SA_DEFAULT_SMALLCLICK))
    var orientation: SAOrientation = SAOrientation(rawValue: Int(SA_DEFAULT_ORIENTATION))!
    var configuration: SAConfiguration = SAConfiguration(rawValue: Int(SA_DEFAULT_CONFIGURATION))!
    var isMoatLimitingEnabled: Bool = Bool(truncating: NSNumber(value: SA_DEFAULT_MOAT_LIMITING_STATE))
    var playback: SARTBStartDelay = SARTBStartDelay(rawValue: Int(SA_DEFAULT_PLAYBACK_MODE))!
    
    private var callback: sacallback? = nil
    
    private var ads = Dictionary<Int, AdState>()
    
    private let control: MediaControl = AwesomeMediaControl()
    
    private let timedVideoEvents: TimedVideoEvents = TimedVideoEvents(delegate: shared)
    private let clickVideoEvents: ClickVideoEvents = ClickVideoEvents(withDelegate: shared)
    
    private var adViewController: VideoViewController? = nil
    
    private override init() {
        super.init()
        // trying to init the SDK very late
        AwesomeAds.initSDK(false)
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // TimedVideoEventsDelegate
    ////////////////////////////////////////////////////////////////////////////
    
    func didStart(placementId: Int) {
        callback?(placementId, SAEvent.adShown)
    }
    
    func didEnd(placementId: Int) {
        callback?(placementId, SAEvent.adEnded)
        
        adViewController?.makeCloseButtonVisible()
        if shouldAutomaticallyCloseAtEnd {
            adViewController?.close()
        }
    }
    
    func didError(placementId: Int) {
        adViewController?.close()
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // ClickVideoEventsDelegate
    ////////////////////////////////////////////////////////////////////////////
    
    func didClickOn(placementId: Int) {
        callback?(placementId, SAEvent.adClicked)
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Internal control methods
    ////////////////////////////////////////////////////////////////////////////
    
    private func load(withPlacementId placementId: Int) {
        let adState = ads[placementId] ?? .none
        
        switch adState {
        case .none:
            ads[placementId] = .loading
            
            let session = SASession()
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
                    self.ads[placementId] = .none
                    self.callback?(placementId, SAEvent.adFailedToLoad)
                    return
                }
                
                guard let ad = response.ads.firstObject as? SAAd,
                    response.isValid(),
                    ad.creative.details.media.isDownloaded else {
                        self.ads[placementId] = .none
                        self.callback?(placementId, SAEvent.adEmpty)
                        return
                }
                
                // create events object
                let events = SAEvents()
                events.setAd(ad, andSession: session)
                if (!self.isMoatLimitingEnabled) {
                    events.disableMoatLimiting()
                }
                
                // reset video events
                self.timedVideoEvents.reset(placementId: placementId,
                                            events: events)
                self.control.add(delegate: self.timedVideoEvents)
                self.clickVideoEvents.reset(placementId: placementId,
                                            events: events,
                                            isParentalGateEnabled: self.isParentalGateEnabled,
                                            isBumperPageEnabled: self.isBumperPageEnabled)
                
                self.ads[placementId] = .hasAd(ad: ad)
                self.callback?(placementId, SAEvent.adLoaded)
            }
            
        case .loading:
            break
        case .hasAd:
            callback?(placementId, SAEvent.adAlreadyLoaded)
        }
    }
    
    private func play(withPlacementId placementId: Int, fromVc viewController: UIViewController) {
        let adState = ads[placementId] ?? .none
        
        switch adState {
        case .hasAd(let ad):
            adViewController = VideoViewController()
            adViewController?.timedVideoEvents = timedVideoEvents
            adViewController?.clickVideoEvents = clickVideoEvents
            adViewController?.control = control
            adViewController?.ad = ad
            adViewController?.showSmallClick = shouldShowSmallClickButton
            adViewController?.showCloseButton = shouldShowCloseButton
            adViewController?.showSafeAdLogo = ad.isSafeAdApproved
            adViewController?.shouldCloseAtEnd = shouldAutomaticallyCloseAtEnd
            viewController.present(adViewController!, animated: true)
            ads[placementId] = .none
            break
        default:
            callback?(placementId, SAEvent.adFailedToShow)
            break
        }
    }
    
    private func hasAdAvailable(placementId: Int) -> Bool {
        let adState = ads[placementId] ?? .none
        switch adState {
        case .hasAd: return true
        default: return false
        }
    }
    
    private func getAd(placementId: Int) -> SAAd? {
        let adState = ads[placementId] ?? .none
        switch adState {
        case .hasAd(let ad): return ad
        default: return nil
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Control methods for backwards compatibility
    ////////////////////////////////////////////////////////////////////////////
    
    @objc(load:)
    public static func load(placementId: Int) {
        shared.load(withPlacementId: placementId)
    }
    
    @objc(play:fromVC:)
    public static func play(withPlacementId placementId: Int,
                            fromViewController viewController: UIViewController) {
        shared.play(withPlacementId: placementId, fromVc: viewController)
    }
    
    @objc(hasAdAvailable:)
    public static func hasAdAvailable(placementId: Int) -> Bool {
        return shared.hasAdAvailable(placementId: placementId)
    }
    
    @objc(getAd:)
    public static func getAd(placementId: Int) -> SAAd? {
        return shared.getAd(placementId: placementId)
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // setters
    ////////////////////////////////////////////////////////////////////////////
    
    @objc(setCallback:)
    public static func setCallback(_ callback: @escaping sacallback) {
        shared.callback = callback
    }
    
    @objc(setTestMode:)
    public static func setTestMode(_ testMode: Bool) {
        shared.isTestingEnabled = testMode
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
        shared.isParentalGateEnabled = parentalGate
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
        shared.isBumperPageEnabled = bumperPage
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
        shared.configuration = config
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
        shared.orientation = orientation
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
        shared.shouldShowCloseButton = close
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
        shared.shouldShowSmallClickButton = smallClick
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
        shared.shouldAutomaticallyCloseAtEnd = close
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
        shared.playback = delay
    }
    
    @objc(videoEvents)
    static func getVideoEvents() -> TimedVideoEvents {
        return shared.timedVideoEvents
    }
}
