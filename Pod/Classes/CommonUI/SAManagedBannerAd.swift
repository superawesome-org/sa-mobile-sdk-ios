//
//  SAManagedBannerAd.swift
//
//  Created by Mark on 08/04/2021.
//

import UIKit

@objc(SAManagedBannerAd) public final class SAManagedBannerAd: UIView {

    internal var finishedLoading = false

    private let session = SASession()
    private let loader = SALoader()
    private var listener: sacallback?
    private let events = SAEvents()
    private var placementId: Int = 0
    private var isParentalGateEnabled = SA_DEFAULT_PARENTALGATE != 0
    private var isBumperPageEnabled = SA_DEFAULT_BUMPERPAGE != 0
    private var moatLimiting = true
    private let awesomeAds = AwesomeAds()

    lazy var webView: WKWebView = {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.allowsInlineMediaPlayback = true
        if #available(iOS 14.0, *) {
            configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        }
        return WKWebView(frame: bounds, configuration: configuration)
    }()

    init() {
        super.init(frame: CGRect.zero)
        initView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }

    private func initView() {
        setConfiguration(value: SAConfiguration(rawValue: SAConfiguration.RawValue(SA_DEFAULT_CONFIGURATION))!)
        setTestMode(value: SA_DEFAULT_TESTMODE != 0)
        addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        webView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        webView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        webView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        webView.navigationDelegate = self
        webView.uiDelegate = self

    }

    private func createHTML(placementId: Int, baseUrl: String) -> String {
        let queryObject = loader.getAwesomeAdsQuery(session)
        let queryParams = queryObject?.filter {
            String(describing: $0.key) != "test"
        }.map { key, value in
            "&\(key)=\(value)"
        }.joined(separator: "") ?? ""

        let scriptHtml = """
                <script type="text/javascript"
    src="\(baseUrl)/ad.js?placement=\(placementId)\(queryParams)"></script>
"""
        return """
<html><header><meta name='viewport' content='width=device-width'/><style>html, body, div { margin: 0px; padding: 0px; } html, body { width: 100%; height: 100%; }</style></header><body>\(scriptHtml)</body></html>
"""
    }

    @objc(load:) public func load(placementId: Int) {
        if let baseUrl = session.getBaseUrl(), let url = URL(string: baseUrl) {
            self.placementId = placementId
            let html: String = createHTML(placementId: placementId, baseUrl: baseUrl)
            print(html)
            if !moatLimiting {
                events.disableMoatLimiting()
            }
            webView.loadHTMLString(html, baseURL: url)
        }
    }

    @objc(setCallback:) public func setCallback(value: sacallback? = nil) {
        self.listener = value
    }

    @objc public func setColor(value: Bool) {
        if (value) {
            backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 0.0)
        } else {
            backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        }
    }

    @objc public func setConfigurationProduction() {
        setConfiguration(value: SAConfiguration.PRODUCTION)
    }

    @objc public func setConfigurationStaging() {
        setConfiguration(value: SAConfiguration.STAGING)
    }

    @objc public func setConfiguration(value: SAConfiguration) {
        session.setConfiguration(value)
    }

    @objc public func setTestMode(value: Bool) {
        session.setTestMode(value)
    }

    @objc public func enableTestMode() {
        session.setTestMode(true)
    }

    @objc public func disableTestMode() {
        session.setTestMode(false)
    }

    @objc public func disableMoatLimiting() {
        moatLimiting = false
    }

    @objc public func enableMoatLimiting() {
        moatLimiting = true

    }

    @objc public func enableBumperPage() {
        isBumperPageEnabled = true
    }

    @objc public func disableBumperPage() {
        isBumperPageEnabled = false
    }

    @objc public func enableParentalGate() {
        isParentalGateEnabled = true
    }

    @objc public func disableParentalGate() {
        isParentalGateEnabled = false
    }

    private func showParentalGate(completion: @escaping() -> Void) {
        if isParentalGateEnabled {

            SAParentalGate.setPgOpenCallback {[weak self]  in
                self?.events.triggerPgOpenEvent()
            }
            SAParentalGate.setPgCanceledCallback {[weak self]  in
                self?.events.triggerPgCloseEvent()
            }
            SAParentalGate.setPgFailedCallback {[weak self]  in
                self?.events.triggerPgFailEvent()
            }
            SAParentalGate.setPgSuccessCallback { [weak self]  in
                self?.events.triggerPgSuccessEvent()
                completion()
            }
            SAParentalGate.play()
        } else {
            completion()
        }
    }

    private func onClick(url: URL) {
        if isBumperPageEnabled {
            SABumperPage.setCallback { [weak self] in
                self?.handle(url: url)
            }
            SABumperPage.play()
        } else {
            handle(url: url)
        }
    }

    private func handle(url: URL) {
        UIApplication.shared.open(url)
    }

}

extension SAManagedBannerAd: WKUIDelegate {

}

extension SAManagedBannerAd: WKNavigationDelegate {

    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        listener?(placementId, SAEvent.adClicked)
        if(finishedLoading && navigationAction.navigationType == .other) {
            if let navUrl = navigationAction.request.url {
                listener?(placementId, SAEvent.adClicked)
                showParentalGate { [weak self] in
                    self?.handle(url: navUrl)
                }
            }
        }
        return nil
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        finishedLoading = true
    }
}
