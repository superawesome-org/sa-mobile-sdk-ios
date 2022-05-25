//
//  SAVideoAd.swift
//  SuperAwesome
//
//  Created by Gabriel Coman on 17/12/2018.
//
import UIKit

enum AdState {
    case none
    case loading
    case hasAd(ad: AdResponse)
}

@objc(SAVideoAd)
public class VideoAd: NSObject, Injectable {
    private static var adRepository: AdRepositoryType = dependencies.resolve()
    private static var logger: LoggerType = dependencies.resolve(param: InterstitialAd.self)

    static var isTestingEnabled: Bool = Constants.defaultTestMode
    static var isParentalGateEnabled: Bool = Constants.defaultParentalGate
    static var isBumperPageEnabled: Bool = Constants.defaultBumperPage
    static var shouldAutomaticallyCloseAtEnd: Bool = Constants.defaultCloseAtEnd
    static var shouldShowCloseButton: Bool = Constants.defaultCloseButton

    static var shouldShowSmallClickButton: Bool = Constants.defaultSmallClick
    static var orientation: Orientation = Constants.defaultOrientation

    static var isMoatLimitingEnabled: Bool = Constants.defaultMoatLimitingState
    static var delay: AdRequest.StartDelay = Constants.defaultStartDelay

    private static var callback: AdEventCallback?

    private static var ads = [Int: AdState]()

    ////////////////////////////////////////////////////////////////////////////
    // Internal control methods
    ////////////////////////////////////////////////////////////////////////////

    @objc(load:)
    public static func load(withPlacementId placementId: Int) {
        let adState = ads[placementId] ?? .none

        switch adState {
        case .none:
            ads[placementId] = .loading

            logger.success("Event callback: ad is started to load for placement \(placementId)")

            adRepository.getAd(placementId: placementId, request: makeAdRequest()) { result in
                switch result {
                case .success(let response): self.onSuccess(placementId, response)
                case .failure(let error): self.onFailure(placementId, error)
                }
            }
        case .loading:
            logger.success("Event callback: ad is loading for placement \(placementId)")
        case .hasAd:
            logger.success("Event callback: adAlreadyLoaded for placement \(placementId)")
            callback?(placementId, .adAlreadyLoaded)
        }
    }

    /**
     * Method that loads an ad into the queue.
     * Ads can only be loaded once and then can be reloaded after they've
     * been played.
     *
     * - Parameters:
     *   - placementId: the Ad placement id to load data for
     *   - lineItemId: id of the line item
     *   - creativeId: id of the creative
     */
    @objc(load: lineItemId: creativeId:)
    public static func load(withPlacementId placementId: Int, lineItemId: Int, creativeId: Int) {
        let adState = ads[placementId] ?? .none

        switch adState {
        case .none:
            ads[placementId] = .loading

            logger.success("Event callback: ad is started to load for placement \(placementId)")

            adRepository.getAd(placementId: placementId,
                               lineItemId: lineItemId,
                               creativeId: creativeId,
                               request: makeAdRequest()) { result in
                switch result {
                case .success(let response): self.onSuccess(placementId, response)
                case .failure(let error): self.onFailure(placementId, error)
                }
            }
        case .loading:
            logger.success("Event callback: ad is loading for placement \(placementId)")
        case .hasAd:
            logger.success("Event callback: adAlreadyLoaded for placement \(placementId)")
            callback?(placementId, .adAlreadyLoaded)
        }
    }

    @objc(play:fromVC:)
    public static func play(withPlacementId placementId: Int, fromVc viewController: UIViewController) {
        let adState = ads[placementId] ?? .none

        switch adState {
        case .hasAd(let ad):
            let config = AdConfig(showSmallClick: shouldShowSmallClickButton,
                                  showSafeAdLogo: ad.advert.showPadlock,
                                  showCloseButton: shouldShowCloseButton,
                                  shouldCloseAtEnd: shouldAutomaticallyCloseAtEnd,
                                  isParentalGateEnabled: isParentalGateEnabled,
                                  isBumperPageEnabled: isBumperPageEnabled,
                                  orientation: orientation)
            if ad.isVpaid {
                let managedVideoAdController = SAManagedAdViewController(adResponse: ad, config: config, callback: callback)
                managedVideoAdController.modalPresentationStyle = .fullScreen
                managedVideoAdController.modalTransitionStyle = .coverVertical

                viewController.present(managedVideoAdController, animated: true)
            } else {
                let adViewController = VideoViewController(adResponse: ad, callback: callback, config: config)
                adViewController.modalPresentationStyle = .fullScreen
                adViewController.modalTransitionStyle = .coverVertical

                viewController.present(adViewController, animated: true)
            }
            ads[placementId] = AdState.none
        default:
            callback?(placementId, .adFailedToShow)
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

    private static func makeAdRequest() -> AdRequest {
        let size = UIScreen.main.bounds.size

        return AdRequest(test: isTestingEnabled,
                         position: AdRequest.Position.fullScreen,
                         skip: AdRequest.Skip.yes,
                         playbackMethod: AdRequest.PlaybackSoundOnScreen,
                         startDelay: delay,
                         instl: AdRequest.FullScreen.on,
                         width: Int(size.width),
                         height: Int(size.height))
    }

    private static func onSuccess(_ placementId: Int, _ response: AdResponse) {
        logger.success("Event callback: adLoaded for placement \(placementId)")

        if !isMoatLimitingEnabled {
            disableMoatLimiting()
        }

        self.ads[placementId] = .hasAd(ad: response)
        callback?(placementId, .adLoaded)
    }

    private static func onFailure(_ placementId: Int, _ error: Error) {
        logger.error("Event callback: adFailedToLoad for placement \(placementId)", error: error)
        self.ads[placementId] = AdState.none
        callback?(placementId, .adFailedToLoad)
    }

    ////////////////////////////////////////////////////////////////////////////
    // setters
    ////////////////////////////////////////////////////////////////////////////

    @objc(setCallback:)
    public static func setCallback(_ callback: AdEventCallback?) {
        self.callback = callback
    }

    @objc(setTestMode:)
    public static func setTestMode(_ testMode: Bool) {
        isTestingEnabled = testMode
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
        isParentalGateEnabled = parentalGate
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
        isBumperPageEnabled = bumperPage
    }

    @objc(enableBumperPage)
    public static func enableBumperPage() {
        setBumperPage(true)
    }

    @objc(disableBumperPage)
    public static func disableBumperPage() {
        setBumperPage(false)
    }

    @available(*, deprecated, message: "Use `AwesomeAds.initSDK()` to select configuration")
    @objc(setConfigurationProduction)
    public static func setConfigurationProduction() { }

    @available(*, deprecated, message: "Use `AwesomeAds.initSDK()` to select configuration")
    @objc(setConfigurationStaging)
    public static func setConfigurationStaging() { }

    @objc(setOrientation:)
    public static func setOriantation(_ orientation: Orientation) {
        self.orientation = orientation
    }

    @objc(setOrientationAny)
    public static func setOrientationAny() {
        setOriantation(.any)
    }

    @objc(setOrientationPortrait)
    public static func setOrientationPortrait() {
        setOriantation(.portrait)
    }

    @objc(setOrientationLandscape)
    public static func setOrientationLandscape() {
        setOriantation(.landscape)
    }

    @objc(setCloseButton:)
    public static func setCloseButton(_ close: Bool) {
        shouldShowCloseButton = close
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
        shouldShowSmallClickButton = smallClick
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
        shouldAutomaticallyCloseAtEnd = close
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
    public static func setPlaybackMode(_ delay: AdRequest.StartDelay) {
        self.delay = delay
    }

    public static func getCallback() -> AdEventCallback? {
        return callback
    }

    @objc(disableMoatLimiting)
    public static func disableMoatLimiting() {
        VideoAd.isMoatLimitingEnabled = false
    }
}
