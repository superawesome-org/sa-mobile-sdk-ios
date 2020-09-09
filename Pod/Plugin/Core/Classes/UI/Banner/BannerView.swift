//
//  Banner.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 20/08/2020.
//

import UIKit

/// Class that abstracts away the process of loading & displaying Banner type Ad.
@objc
public class BannerView: UIView, Injectable {
    
    private lazy var imageProvider: ImageProviderType = dependencies.resolve()
    private lazy var controller: AdControllerType = dependencies.resolve()
    private lazy var logger: LoggerType = dependencies.resolve(param: BannerView.self)
    
    private var webView: WebView?
    private var padlock: UIButton?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    // MARK: - Internal functions
    
    func configure(adResponse: AdResponse, delegate: AdEventCallback?) {
        setAdResponse(adResponse)
        setCallback(delegate)
    }
    
    // MARK: - Public functions
    
    /**
     * Method that loads an ad into the queue.
     * Ads can only be loaded once and then can be reloaded after they've
     * been played.
     *
     * @param placementId   the Ad placement id to load data for
     */
    public func load(_ placementId: Int) {
        logger.info("load() for: \(placementId)")
        controller.load(placementId, makeAdRequest())
    }
    
    /// Method that, if an ad data is loaded, will play the content for the user
    public func play() {
        logger.info("play()")
        // guard against invalid ad formats
        guard let adResponse = controller.adResponse, let html = adResponse.html,
            adResponse.ad.creative.format != CreativeFormatType.video, !controller.closed else {
                controller.adFailedToShow()
                return
        }
        
        addWebView()
        
        controller.triggerImpressionEvent()
        
        showPadlockIfNeeded()
        
        webView?.loadHTML(html, withBase: adResponse.baseUrl,
                          sourceSize: CGSize(width: adResponse.ad.creative.details.width,
                                             height: adResponse.ad.creative.details.height))
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
    public func close() {
        //        visibilityDelegate = nil
        controller.close()
        removeWebView()
    }
    
    /**
     * Method that returns whether ad data for a certain placement
     * has already been loaded
     *
     * @return              true or false
     */
    public func hasAdAvailable() -> Bool { controller.adResponse != nil }
    
    /// Method that gets whether the banner is closed or not
    public func isClosed() -> Bool { controller.closed }
    
    /// Callback function
    public func setCallback(_ callback: AdEventCallback?) { controller.delegate = callback }
    
    public func setTestMode(_ value: Bool) { controller.testEnabled = value }
    
    public func enableTestMode() { setTestMode(true) }
    
    public func disableTestMode() { setTestMode(false) }
    
    @available(*, deprecated, message: "Use `AwesomeAdsSdk.Configuration` instead")
    public func setConfigurationProduction() { }
    
    @available(*, deprecated, message: "Use `AwesomeAdsSdk.Configuration` instead")
    public func setConfigurationStaging() { }
    
    public func setParentalGate(_ value: Bool) { controller.parentalGateEnabled = value }
    
    public func enableParentalGate() { setParentalGate(true) }
    
    public func disableParentalGate() { setParentalGate(false) }
    
    public func setBumperPage(_ value: Bool) { controller.bumperPageEnabled = value }
    
    public func enableBumperPage() { setBumperPage(true) }
    
    public func disableBumperPage() { setBumperPage(false) }
    
    public func setColorTransparent() { setColor(true) }
    
    public func setColorGray() { setColor(false) }
    
    public func setColor(_ value: Bool) {
        backgroundColor = value ?
            UIColor.clear : UIColor(red: 224.0 / 255.0, green: 224.0 / 255.0, blue: 224.0 / 255.0, alpha: 1)
    }
    
    public func disableMoatLimiting() { controller.moatLimiting = false }
    
    //    public func setBannerVisibilityDelegate(_ delegate: SABannerAdVisibilityDelegate) {
    //        visibilityDelegate = delegate
    //    }
    
    // MARK: - Private functions
    
    private func initialize() {
        setColor(false)
    }
    
    private func setAdResponse(_ adResponse: AdResponse) {
        controller.adResponse = adResponse
    }
    
    private func makeAdRequest() -> AdRequest {
        AdRequest(test: controller.testEnabled,
                  pos: AdRequest.Position.aboveTheFold,
                  skip: AdRequest.Skip.no,
                  playbackmethod: AdRequest.PlaybackSoundOnScreen,
                  startdelay: AdRequest.StartDelay.preRoll,
                  instl: AdRequest.FullScreen.off,
                  w: Int(frame.size.width),
                  h: Int(frame.size.height))
    }
    
    private func addWebView() {
        removeWebView()
        
        webView = WebView(frame: CGRect.zero, configuration: WebView.defaultConfiguration())
        
        if let view = webView {
            view.delegate = self
            view.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(view)
            
            let aspectRatio = controller.adResponse?.aspectRatio() ?? 1.0
            logger.info("aspectRatio(): \(aspectRatio)")
            NSLayoutConstraint.activate([
                view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: aspectRatio, constant: 0),
                
                view.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 1.0, constant: 0),
                view.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0, constant: 0).withPriority(250),
                
                view.heightAnchor.constraint(lessThanOrEqualTo: self.heightAnchor, multiplier: 1.0, constant: 0),
                view.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.0, constant: 0).withPriority(250),
                
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
                view.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
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
        // TODO: Implement viewable status
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
