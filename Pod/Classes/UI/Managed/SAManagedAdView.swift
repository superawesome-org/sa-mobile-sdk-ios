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

    private var callback: AdEventCallback?
    private var placementId: Int = 0
    private var bridge: AdViewJavaScriptBridge?

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

    public func load(placementId: Int, html: String, baseUrl: String?) {
        if let baseUrl = baseUrl, let url = URL(string: baseUrl) {
            self.placementId = placementId

            logger.info(html)

            webView.loadHTMLString(html, baseURL: url)

            if #available(iOS 14.5, *) {
                sknetworkManager.startImpression(lineItemId: placementId, creativeId: 1)
            }
        }
    }

    func setBridge(bridge: AdViewJavaScriptBridge? = nil) {
        self.bridge = bridge
    }

    public func setCallback(value: AdEventCallback? = nil) {
        self.callback = value
    }

    public func setColor(value: Bool) {
        backgroundColor = value ? .clear : Constants.backgroundGray
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
        if finishedLoading && navigationAction.navigationType == .other {
            if let url = navigationAction.request.url {
                bridge?.onAdClick(url: url)
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

    // Error handling

    public func webView(_: WKWebView, didFail: WKNavigation!, withError: Error) {
        onEvent(event: .adFailedToLoad)
    }

    public func webView(_: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error) {
        onEvent(event: .adFailedToLoad)
    }
}

extension SAManagedAdView: AdViewJavaScriptBridge {
    // Propagate events to the callback bridge
    func onAdClick(url: URL) {
        bridge?.onAdClick(url: url)
    }

    // Propagate events to the callback bridge
    func onEvent(event: AdEvent) {
        bridge?.onEvent(event: event)
    }
}
