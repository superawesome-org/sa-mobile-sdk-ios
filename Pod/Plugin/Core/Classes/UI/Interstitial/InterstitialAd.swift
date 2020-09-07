//
//  InterstitialAd.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 04/09/2020.
//

import UIKit

public class InterstitialAd: Injectable {
    private static var adRepository: AdRepositoryType = dependencies.resolve()
    private static var logger: LoggerType = dependencies.resolve(param: InterstitialAd.self)
    
    private(set) static var isParentalGateEnabled: Bool = false
    private(set) static var isBumperPageEnabled: Bool = false
    private(set) static var isTestingEnabled: Bool = false
    private(set) static var orientation: SAOrientation = .ANY
    private(set) static var configuration = SA_DEFAULT_CONFIGURATION
    private(set) static var isMoatLimitingEnabled: Bool = true
    
    private static var delegate: AdEventCallback?
    private static var adResponse: AdResponse?
    private static var placementId: Int { adResponse?.placementId ?? 0 }
    
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
        
        adRepository.getAd(placementId: placementId,
                           request: makeAdRequest()) { result in
                            switch result {
                            case .success(let response): self.onSuccess(response)
                            case .failure(let error): self.onFailure(error)
                            }
                            
        }
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
        guard let adResponse = adResponse, adResponse.ad.creative.format != CreativeFormatType.video else {
                delegate?(placementId, .adFailedToShow)
                return
        }
        
        let controller = InterstitialAdViewController(adResponse: adResponse,
                                                      parentGateEnabled: isParentalGateEnabled,
                                                      bumperPageEnabled: isBumperPageEnabled,
                                                      testingEnabled: isTestingEnabled,
                                                      orientation: orientation,
                                                      delegate: delegate)
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .coverVertical
        parent?.present(controller, animated: true, completion: nil)
    }
    
    /**
     * Method that returns whether ad data for a certain placement
     * has already been loaded
     *
     * @param placementId   the Ad placement id to check for
     * @return              true or false
     */
    public class func hasAdAvailable(_ placementId: Int) -> Bool {
        adResponse != nil
    }
    
    public class func setCallback(_ callback: @escaping AdEventCallback) {
        delegate = callback
    }
    
    public class func setConfiguration(_ value: Int) {
    }
    
    public class func setConfigurationProduction() {
    }
    
    public class func setConfigurationStaging() {
    }
    
    public class func setOrientation(_ value: SAOrientation) {
    }
    
    public class func setOrientationAny() {
    }
    
    public class func setOrientationPortrait() {
    }
    
    public class func setOrientationLandscape() {
    }
    
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
    
    private static func onSuccess(_ response: AdResponse) {
        logger.success("Ad load successful for \(response.placementId)")
        self.adResponse = response
        delegate?(placementId, .adLoaded)
    }
    
    private static func onFailure(_ error: Error) {
        logger.error("Ad load failed", error: error)
        delegate?(placementId, .adFailedToLoad)
    }
}
