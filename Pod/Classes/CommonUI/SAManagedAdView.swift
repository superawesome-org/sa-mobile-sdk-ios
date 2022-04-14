//
//  SAManagedAdView.swift
//
//  Created by Mark on 08/04/2021.
//

import UIKit
import WebKit

private let overrideConsoleScript = """
    function log(emoji, type, args) {
      window.webkit.messageHandlers.logging.postMessage(
        `${emoji} JS ${type}: ${Object.values(args)
          .map(v => typeof(v) === "undefined" ? "undefined" : typeof(v) === "object" ? JSON.stringify(v) : v.toString())
          .map(v => v.substring(0, 3000)) // Limit msg to 3000 chars
          .join(", ")}`
      )
    }

    let originalLog = console.log
    let originalWarn = console.warn
    let originalError = console.error
    let originalDebug = console.debug

    console.log = function() { log("📗", "log", arguments); originalLog.apply(null, arguments) }
    console.warn = function() { log("📙", "warning", arguments); originalWarn.apply(null, arguments) }
    console.error = function() { log("📕", "error", arguments); originalError.apply(null, arguments) }
    console.debug = function() { log("📘", "debug", arguments); originalDebug.apply(null, arguments) }

    window.addEventListener("error", function(e) {
       log("💥", "Uncaught", [`${e.message} at ${e.filename}:${e.lineno}:${e.colno}`])
    })

"""

private let bridgeScript = """
    function postMessageToBridge(message) {
        window.webkit.messageHandlers.bridge.postMessage(message);
    }

    var SA_AD_JS_BRIDGE = {
        adLoaded: function() { postMessageToBridge("\(AdEvent.adLoaded.rawValue)"); },
        adEmpty: function() { postMessageToBridge("\(AdEvent.adEmpty.rawValue)"); },
        adFailedToLoad: function() { postMessageToBridge("\(AdEvent.adFailedToLoad.rawValue)"); },
        adAlreadyLoaded: function() { postMessageToBridge("\(AdEvent.adAlreadyLoaded.rawValue)"); },
        adShown: function() { postMessageToBridge("\(AdEvent.adShown.rawValue)"); },
        adFailedToShow: function() { postMessageToBridge("\(AdEvent.adFailedToShow.rawValue)"); },
        adClicked: function() { postMessageToBridge("\(AdEvent.adClicked.rawValue)"); },
        adEnded: function() { postMessageToBridge("\(AdEvent.adEnded.rawValue)"); },
        adClosed: function() { postMessageToBridge("\(AdEvent.adClosed.rawValue)"); }
    };
"""

class LoggingMessageHandler: NSObject, WKScriptMessageHandler {
    private var logger: LoggerType

    init(_ logger: LoggerType) {
        self.logger = logger
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let log = String(describing: message.body)
        logger.info(log)
    }
}

class AdViewMessageHandler: NSObject, WKScriptMessageHandler {
    private var bridge: AdViewJavaScriptBridge?

    init(_ bridge: AdViewJavaScriptBridge?) {
        self.bridge = bridge
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let body = String(describing: message.body)
        guard let id = Int(body), let event = AdEvent(rawValue: id) else { return }
        bridge?.onEvent(event: event)
    }
}

@objc(SAManagedAdView) public final class SAManagedAdView: UIView, Injectable {

    internal var finishedLoading = false

    private let session = SASession()
    private let loader = SALoader()
    private var callback: AdEventCallback?
    private let events = SAEvents()
    private var placementId: Int = 0
    private var isParentalGateEnabled = SA_DEFAULT_PARENTALGATE != 0
    private var isBumperPageEnabled = SA_DEFAULT_BUMPERPAGE != 0
    private var moatLimiting = true
    private var bridge: AdViewJavaScriptBridge?

    @available(iOS 14.5, *)
    private lazy var sknetworkManager: SKAdNetworkManager = dependencies.resolve()
    private var logger: LoggerType = dependencies.resolve(param: SAManagedAdView.self)

    lazy var webView: WKWebView = {
        let userContentController = WKUserContentController()
        userContentController.add(LoggingMessageHandler(logger), name: "logging")
        userContentController.add(AdViewMessageHandler(self), name: "bridge")
        userContentController.addUserScript(WKUserScript(source: overrideConsoleScript,
                                                         injectionTime: .atDocumentStart,
                                                         forMainFrameOnly: false))
        userContentController.addUserScript(WKUserScript(source: bridgeScript,
                                                         injectionTime: .atDocumentStart,
                                                         forMainFrameOnly: false))

        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true

        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.userContentController = userContentController

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
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 0),
            webView.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: 0),
            webView.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: 0),
            webView.topAnchor.constraint(equalTo: safeTopAnchor, constant: 0)
        ])
        webView.navigationDelegate = self
        webView.uiDelegate = self
    }

    @objc(load:html:) public func load(placementId: Int, html: String) {
        if let baseUrl = session.getBaseUrl(), let url = URL(string: baseUrl) {
            self.placementId = placementId

            logger.info(html)

            if !moatLimiting {
                events.disableMoatLimiting()
            }

            webView.loadHTMLString(html, baseURL: url)

            if #available(iOS 14.5, *) {
                sknetworkManager.startImpression(lineItemId: placementId, creativeId: 1)
            }
        }
    }

    func setBridge(bridge: AdViewJavaScriptBridge? = nil) {
        self.bridge = bridge
    }

    @objc(setCallback:) public func setCallback(value: AdEventCallback? = nil) {
        self.callback = value
    }

    @objc public func setColor(value: Bool) {
        if value {
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

    @objc public func setParentalGate(_ isEnabled: Bool) {
        isParentalGateEnabled = isEnabled
    }

    @objc public func setBumperPage(_ isEnabled: Bool) {
        isBumperPageEnabled = isEnabled
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

    func close() {
        if #available(iOS 14.5, *) {
            sknetworkManager.endImpression()
            webView.closeAllMediaPresentations()
        }

        // Stop any playing media
        webView.loadHTMLString("", baseURL: nil)
    }
}

extension SAManagedAdView: WKNavigationDelegate, WKUIDelegate {
    public func webView(_ webView: WKWebView,
                        createWebViewWith configuration: WKWebViewConfiguration,
                        for navigationAction: WKNavigationAction,
                        windowFeatures: WKWindowFeatures) -> WKWebView? {
        callback?(placementId, .adClicked)
        if finishedLoading && navigationAction.navigationType == .other {
            if let navUrl = navigationAction.request.url {
                callback?(placementId, .adClicked)
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

    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}

extension SAManagedAdView: AdViewJavaScriptBridge {
    // Propagate events to the callback bridge
    func onEvent(event: AdEvent) {
        bridge?.onEvent(event: event)
    }
}
