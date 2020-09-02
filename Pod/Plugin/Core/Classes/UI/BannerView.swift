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
    
    private lazy var adRepository: AdRepositoryType = dependencies.resolve()
    private lazy var eventRepository: EventRepositoryType = dependencies.resolve()
    private lazy var imageProvider: ImageProviderType = dependencies.resolve()
    private lazy var logger: LoggerType = dependencies.resolve(param: BannerView.self)
    
    private var adResponse: AdResponse?
    private var testEnabled = false
    private var parentalGateEnabled = false
    private var bumperPageEnabled = false
    private var moatLimiting = true
    private var closed = false
    private var delegate: AdEventCallback?
    private var visibilityDelegate: SABannerAdVisibilityDelegate?
    private var webView: WebView?
    private var parentalGate: ParentalGate?
    private var parentalGateBlock: VoidBlock?
    
    // MARK: - Public functions
    
    /**
     * Method that loads an ad into the queue.
     * Ads can only be loaded once and then can be reloaded after they've
     * been played.
     *
     * @param placementId   the Ad placement id to load data for
     */
    public func load(_ placementId: Int) {
        logger.info("Banner.load: \(placementId)")
        
        adRepository.getAd(placementId: placementId,
                           request: makeAdRequest()) { [weak self] result in
                            switch result {
                            case .success(let response): self?.onSuccess(response)
                            case .failure(let error): self?.onFailure(error)
                            }
                            
        }
    }
    
    /// Method that, if an ad data is loaded, will play the content for the user
    public func play() {
        logger.info("BannerView.play()")
        // guard against invalid ad formats
        guard let adResponse = adResponse, let html = adResponse.html,
            adResponse.ad.creative.format != CreativeFormatType.video, !closed else {
                delegate?(0, .adFailedToShow)
                return
        }
        
        addWebView()
        
        eventRepository.impression(adResponse, completion: nil)
        
        showPadlockIfNeeded()
        
        webView?.loadHTML(html, witBase: adResponse.baseUrl)
    }
    
    private func showPadlockIfNeeded() {
        guard adResponse?.ad.show_padlock ?? false  else { return }
        
        let padlock = UIButton(frame: CGRect.zero)
        padlock.setImage(imageProvider.safeAdImage, for: .normal)
        padlock.addTarget(self, action: #selector(padlockAction), for: .touchUpInside)
        
        webView?.addSubview(padlock)
    }
    
    /// Method that is called to close the ad
    public func close() {
        visibilityDelegate = nil
        delegate?(adResponse?.placementId ?? 0, .adClosed)
        adResponse = nil
        removeWebView()
        closed = true
    }
    
    /**
     * Method that returns whether ad data for a certain placement
     * has already been loaded
     *
     * @return              true or false
     */
    public func hasAdAvailable() -> Bool { adResponse != nil }
    
    /// Method that gets whether the banner is closed or not
    public func isClosed() -> Bool { closed }
    
    /**
     * Method that resizes the ad object
     *
     * @param toframe the new frame to resize to
     */
    public func resize(_ toframe: CGRect) {
    }
    
    /// Callback function
    public func setCallback(_ callback: @escaping AdEventCallback) { delegate = callback }
    
    public func enableTestMode() { testEnabled = true }
    
    public func disableTestMode() { testEnabled = false }
    
    public func setConfigurationProduction() {
    }
    
    public func setConfigurationStaging() {
    }
    
    public func setConfiguration(_ value: Int) {
    }
    
    
    public func setTestMode(_ value: Bool) { testEnabled = value }
    
    public func setParentalGate(_ value: Bool) { parentalGateEnabled = value }
    
    public func setBumperPage(_ value: Bool) { bumperPageEnabled = value }
    
    public func setColorTransparent() { setColor(true) }
    
    public func setColorGray() { setColor(false) }
    
    public func setColor(_ value: Bool) {
        backgroundColor = value ?
            UIColor.clear : UIColor(red: 224.0 / 255.0, green: 224.0 / 255.0, blue: 224.0 / 255.0, alpha: 1)
    }
    
    public func disableMoatLimiting() { moatLimiting = false }
    
    public func enableBumperPage() { bumperPageEnabled = true }
    
    public func disableBumperPage() { bumperPageEnabled = false }
    
    public func enableParentalGate() { parentalGateEnabled = true }
    
    public func disableParentalGate() { parentalGateEnabled = false }
    
    public func setBannerVisibilityDelegate(_ delegate: SABannerAdVisibilityDelegate) {
        visibilityDelegate = delegate
    }
    
    // MARK: - Private functions
    
    private func onSuccess(_ response: AdResponse) {
        logger.success("Ad load successful for \(response.placementId)")
        self.adResponse = response
        delegate?(response.placementId, .adLoaded)
    }
    
    private func onFailure(_ error: Error) {
        logger.error("Ad load failed", error: error)
    }
    
    private func makeAdRequest() -> AdRequest {
        AdRequest(test: testEnabled,
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
            
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
                view.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0)
            ])
        }
    }
    
    private func removeWebView() {
        webView?.removeFromSuperview()
        webView = nil
    }
    
    private func addPadLock() {
        guard adResponse?.ad.show_padlock ?? false else { return }
        
        let padlock = UIButton(frame: CGRect.zero)
        padlock.setImage(imageProvider.safeAdImage, for: .normal)
        padlock.addTarget(self, action: #selector(padlockAction), for: .touchUpInside)
        
        webView?.addSubview(padlock)
    }
    
    @objc private func padlockAction() {
        showParentalGateIfNeeded( withCompletion: { [weak self]  in
            self?.showSuperAwesomeWebPageInSafari()
        })
    }
    
    private func showParentalGateIfNeeded(withCompletion completion: @escaping VoidBlock) {
        if parentalGateEnabled {
            parentalGate?.stop()
            parentalGate = dependencies.resolve() as ParentalGate
            parentalGate?.delegate = self
            parentalGate?.show()
            parentalGateBlock = completion
        } else {
            completion()
        }
    }
    
    private func showSuperAwesomeWebPageInSafari() {
        let bumperCallback = {
            if let url = URL(string: "https://ads.superawesome.tv/v2/safead") {
                UIApplication.shared.open( url, options: [:], completionHandler: nil)
            }
        }
        
        if bumperPageEnabled {
            //SABumperPage.callback = bumperCallback
            //SABumperPage.play()
        } else {
            bumperCallback()
        }
    }
    
    /// Method that is called when a user clicks / taps on an ad
    private func onAdClicked(_ urlString: String) {
        
    }
    
    private func navigateToUrl(_ url: URL) {
        guard let adResponse = adResponse else { return }
        delegate?(adResponse.placementId, .adClicked)
        eventRepository.click(adResponse, completion: nil)
        
        UIApplication.shared.open( url, options: [:], completionHandler: nil)
    }
}

extension BannerView: ParentalGateDelegate {
    func parentalGateSuccess() {
        parentalGateBlock?()
        guard let adResponse = adResponse else { return }
        eventRepository.parentalGateSuccess(adResponse, completion: nil)
    }
    
    func parentalGateOpenned() {
        guard let adResponse = adResponse else { return }
        eventRepository.parentalGateOpen(adResponse, completion: nil)
    }
    
    func parentalGateCancelled() {
        guard let adResponse = adResponse else { return }
        eventRepository.parentalGateClose(adResponse, completion: nil)
    }
    
    func parentalGateFailed() {
        guard let adResponse = adResponse else { return }
        eventRepository.parentalGateFail(adResponse, completion: nil)
    }
}

extension BannerView: WebViewDelegate {
    func webViewOnStart() {
        
    }
    
    func webViewOnError() {
        
    }
    
    func webViewOnClick(url: URL) {
        logger.info("BannerView.webViewOnClick")
        showParentalGateIfNeeded { [weak self] in
            self?.onAdClicked(url.absoluteString)
        }
    }
}
