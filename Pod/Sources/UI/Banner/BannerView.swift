//
//  Banner.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 20/08/2020.
//

import UIKit

/// Class that abstracts away the process of loading & displaying Banner type Ad.
public class BannerView: UIView, Injectable {

    private lazy var imageProvider: ImageProviderType = dependencies.resolve()
    private lazy var controller: AdControllerType = dependencies.resolve()
    private lazy var logger: LoggerType = dependencies.resolve(param: BannerView.self)
    @available(iOS 14.5, *)
    private lazy var sknetworkManager: SKAdNetworkManager = dependencies.resolve()

    private var webView: WebView?
    private var padlock: UIButton?
    private var viewableDetector: ViewableDetectorType?
    private var hasBeenVisible: VoidBlock?
    private var moatRepository: MoatRepositoryType?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    // MARK: - Internal functions

    func configure(adResponse: AdResponse, delegate: AdEventCallback?, hasBeenVisible: VoidBlock?) {
        self.hasBeenVisible = hasBeenVisible
        setAdResponse(adResponse)
        setCallback(delegate)
    }

    // MARK: - Public functions

    /**
     * Method that loads an ad into the queue.
     * Ads can only be loaded once and then can be reloaded after they've
     * been played.
     *
     * - Parameter placementId: the Ad placement id to load data for
     */
    @objc
    public func load(_ placementId: Int) {
        logger.info("load() for: \(placementId)")
        controller.load(placementId, makeAdRequest())
    }

    public func getAd() -> Ad? {
        return controller.adResponse?.advert
    }

    public func removeAd() {
        controller.adResponse = nil
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
    @objc
    public func load(_ placementId: Int, lineItemId: Int, creativeId: Int) {
        logger.info("load() for: \(placementId)")
        controller.load(placementId, lineItemId: lineItemId, creativeId: creativeId, makeAdRequest())
    }

    /// Method that, if an ad data is loaded, will play the content for the user
    @objc
    public func play() {
        logger.info("play()")
        // guard against invalid ad formats
        guard let adResponse = controller.adResponse, let html = adResponse.html,
              adResponse.advert.creative.format != CreativeFormatType.video, !controller.closed else {
            controller.adFailedToShow()
            return
        }

        addWebView()

        controller.triggerImpressionEvent()

        showPadlockIfNeeded()
        if #available(iOS 14.5, *) {
            sknetworkManager.startImpression(lineItemId: adResponse.advert.lineItemId, creativeId: adResponse.advert.creative.id)
        }

        let fullHtml = startMoat(adResponse: adResponse, html: html)
        webView?.loadHTML(fullHtml, withBase: adResponse.baseUrl,
                          sourceSize: CGSize(width: adResponse.advert.creative.details.width,
                                             height: adResponse.advert.creative.details.height))
    }

    private func startMoat(adResponse: AdResponse, html: String) -> String {
        moatRepository = dependencies.resolve(param: adResponse, controller.moatLimiting) as MoatRepositoryType
        let moatScript = moatRepository?.startMoatTracking(forDisplay: webView)
        return "\(html)\(moatScript ?? "")"
    }

    private func showPadlockIfNeeded() {
        guard controller.showPadlock, let webView = webView  else { return }

        let padlock = UIButton(frame: CGRect.zero)
        padlock.setImage(imageProvider.safeAdImage, for: .normal)
        padlock.addTarget(self, action: #selector(padlockAction), for: .touchUpInside)

        webView.addSubview(padlock)

        NSLayoutConstraint.activate([
            padlock.leadingAnchor.constraint(equalTo: webView.leadingAnchor, constant: 12.0),
            padlock.topAnchor.constraint(equalTo: webView.topAnchor, constant: 12.0)
        ])

        self.padlock = padlock
    }

    /// Method that is called to close the ad
    @objc
    public func close() {
        viewableDetector = nil
        _ = moatRepository?.stopMoatTrackingForDisplay()
        moatRepository = nil
        controller.close()
        removeWebView()
        if #available(iOS 14.5, *) {
            sknetworkManager.endImpression()
        }
    }

    /**
     * Method that returns whether ad data for a certain placement
     * has already been loaded
     *
     * @return              true or false
     */
    @objc
    public func hasAdAvailable() -> Bool { controller.adResponse != nil }

    /// Method that gets whether the banner is closed or not
    @objc
    public func isClosed() -> Bool { controller.closed }

    /// Callback function
    @objc
    public func setCallback(_ callback: AdEventCallback?) { controller.callback = callback }

    @objc
    public func setTestMode(_ value: Bool) { controller.testEnabled = value }

    @objc
    public func enableTestMode() { setTestMode(true) }

    @objc
    public func disableTestMode() { setTestMode(false) }

    @objc
    public func setParentalGate(_ value: Bool) { controller.parentalGateEnabled = value }

    @available(*, deprecated, message: "Use `AwesomeAdsSdk.Configuration` instead")
    @objc
    public func setConfigurationProduction() { }

    @available(*, deprecated, message: "Use `AwesomeAdsSdk.Configuration` instead")
    @objc
    public func setConfigurationStaging() { }

    @objc
    public func enableParentalGate() { setParentalGate(true) }

    @objc
    public func disableParentalGate() { setParentalGate(false) }

    @objc
    public func setBumperPage(_ value: Bool) { controller.bumperPageEnabled = value }

    @objc
    public func enableBumperPage() { setBumperPage(true) }

    @objc
    public func disableBumperPage() { setBumperPage(false) }

    @objc
    public func setColorTransparent() { setColor(true) }

    @objc
    public func setColorGray() { setColor(false) }

    public func setColor(_ value: Bool) {
        backgroundColor = value ? UIColor.clear : Constants.backgroundGray
    }

    @objc
    public func disableMoatLimiting() { controller.moatLimiting = false }

    // MARK: - Private functions

    private func initialize() {
        setColor(false)
    }

    private func setAdResponse(_ adResponse: AdResponse) {
        controller.adResponse = adResponse
    }

    private func makeAdRequest() -> AdRequest {
        RequestFactoryImpl().makeRequest(isTestEnabled: controller.testEnabled,
                                                screen: .bannerView,
                                                size: frame.size)
    }

    private func addWebView() {
        removeWebView()

        webView = WebView(frame: CGRect.zero, configuration: WebView.defaultConfiguration())

        if let view = webView {
            view.delegate = self
            view.translatesAutoresizingMaskIntoConstraints = false

            addSubview(view)
            NSLayoutConstraint.activate([
                view.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 1.0, constant: 0),
                view.heightAnchor.constraint(lessThanOrEqualTo: self.heightAnchor, multiplier: 1.0, constant: 0),
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
                view.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
            ])
        }
    }

    private func removeWebView() {
        padlock?.removeFromSuperview()
        padlock = nil
        webView?.removeFromSuperview()
        webView = nil
    }

    private func addPadLock() {
        guard controller.showPadlock else { return }

        let padlock = UIButton(frame: CGRect.zero)
        padlock.setImage(imageProvider.safeAdImage, for: .normal)
        padlock.addTarget(self, action: #selector(padlockAction), for: .touchUpInside)

        webView?.addSubview(padlock)
    }

    @objc private func padlockAction() { controller.handleSafeAdTap() }
}

extension BannerView: WebViewDelegate {
    func webViewOnStart() {
        logger.info("webViewOnStart")
        controller.adShown()

        viewableDetector = dependencies.resolve() as ViewableDetectorType
        viewableDetector?.start(for: self, hasBeenVisible: { [weak self] in
            self?.controller.triggerViewableImpression()
            self?.hasBeenVisible?()
        })
    }

    func webViewOnError() {
        logger.info("webViewOnError")
        controller.adFailedToShow()
    }

    func webViewOnClick(url: URL) {
        logger.info("webViewOnClick")
        controller.handleAdTap(url: url)
    }
}
