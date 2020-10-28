//
//  InterstitialAd.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 04/09/2020.
//

import UIKit

public class InterstitialAd: Injectable {
    private static var controller: AdControllerType = dependencies.resolve()
    private static var logger: LoggerType = dependencies.resolve(param: InterstitialAd.self)
    
    private(set) static var isParentalGateEnabled: Bool = Constants.defaultParentalGate
    private(set) static var isBumperPageEnabled: Bool = Constants.defaultBumperPage
    private(set) static var isTestingEnabled: Bool = Constants.defaultTestMode
    private(set) static var orientation: Orientation = Constants.defaultOrientation
    private(set) static var isMoatLimitingEnabled: Bool = Constants.defaultMoatLimitingState
        
    // MARK: - Public functions
    
    /**
     * Method that loads an ad into the queue.
     * Ads can only be loaded once and then can be reloaded after they've
     * been played.
     *
     * @param placementId   the Ad placement id to load data for
     */
    public class func load(_ placementId: Int) {
        logger.info("load() for: \(placementId)")
        controller.load(placementId, makeAdRequest())
    }
    
    /**
     * Method that, if an ad data is loaded, will play
     * the content for the user
     *
     * @param placementId   the Ad placement id to play an ad for
     * @param parent        the parent view controller
     */
    public class func play(_ placementId: Int, fromVC parent: UIViewController?) {
        logger.info("play()")
        // guard against invalid ad formats
        guard let adResponse = controller.adResponse, adResponse.ad.creative.format != CreativeFormatType.video else {
                controller.adFailedToShow()
                return
        }
        
        let viewController = InterstitialAdViewController(adResponse: adResponse,
                                                      parentGateEnabled: isParentalGateEnabled,
                                                      bumperPageEnabled: isBumperPageEnabled,
                                                      testingEnabled: isTestingEnabled,
                                                      orientation: orientation,
                                                      delegate: self.controller.delegate)
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .coverVertical
        parent?.present(viewController, animated: true, completion: nil)
    }
    
    /**
     * Method that returns whether ad data for a certain placement
     * has already been loaded
     *
     * @param placementId   the Ad placement id to check for
     * @return              true or false
     */
    public class func hasAdAvailable(_ placementId: Int) -> Bool { controller.adAvailable }
    
    public class func setCallback(_ callback: @escaping AdEventCallback) { controller.delegate = callback }
    
    @available(*, deprecated, message: "Use `AwesomeAdsSdk.Configuration` instead")
    public class func setConfiguration(_ value: Int) { }
    
    @available(*, deprecated, message: "Use `AwesomeAdsSdk.Configuration` instead")
    public class func setConfigurationProduction() { }
    
    @available(*, deprecated, message: "Use `AwesomeAdsSdk.Configuration` instead")
    public class func setConfigurationStaging() { }
    
    public class func setOrientation(_ orientation: Orientation) { self.orientation = orientation }
    
    public class func setOrientationAny() { setOrientation(.any) }
    
    public class func setOrientationPortrait() { setOrientation(.portrait) }
    
    public class func setOrientationLandscape() { setOrientation(.landscape) }
    
    public class func setTestMode(_ value: Bool) { isTestingEnabled = value }
    
    public class func enableTestMode() { setTestMode(true) }
    
    public class func disableTestMode() { setTestMode(false) }
    
    public class func disableMoatLimiting() { isMoatLimitingEnabled = false }
    
    public class func setBumperPage(_ value: Bool) { isBumperPageEnabled = value }
    
    public class func enableBumperPage() { setBumperPage(true) }
    
    public class func disableBumperPage() { setBumperPage(false) }
    
    public class func setParentalGate(_ value: Bool) { isParentalGateEnabled = value }
    
    public class func enableParentalGate() { setParentalGate(true) }
    
    public class func disableParentalGate() { setParentalGate(false) }
    
    // MARK: - Private functions
    
    private static func makeAdRequest() -> AdRequest {
        let size = UIScreen.main.bounds.size
        
        return AdRequest(test: isTestingEnabled,
                         pos: AdRequest.Position.fullScreen,
                         skip: AdRequest.Skip.yes,
                         playbackmethod: AdRequest.PlaybackSoundOnScreen,
                         startdelay: AdRequest.StartDelay.preRoll,
                         instl: AdRequest.FullScreen.on,
                         w: Int(size.width),
                         h: Int(size.height))
    }
}
