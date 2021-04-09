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
    private var placementId: Int = 0
    
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
    
    private func initView(){
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
        let queryParams = queryObject?.filter{
            String(describing: $0.key) != "test"
        }.map{ key,value in
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
        if let baseUrl = session.getBaseUrl(), let url = URL(string: baseUrl){
            self.placementId = placementId
            let html:String = createHTML(placementId: placementId, baseUrl: baseUrl)
            print(html)
            webView.loadHTMLString(html, baseURL: url)
        }
    }
    
    @objc(setCallback:) public func setCallback(value: sacallback? = nil) {
        self.listener = value
    }
    
    @objc public func setColor(value: Bool) {
        if (value) {
            backgroundColor = UIColor(red:224/255, green:224/255, blue:224/255, alpha: 0.0)
        } else {
            backgroundColor = UIColor(red:224/255, green:224/255, blue:224/255, alpha: 1.0)
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
    
}

extension SAManagedBannerAd: WKUIDelegate{
    
}

extension SAManagedBannerAd : WKNavigationDelegate{
    
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        listener?(placementId, SAEvent.adClicked)
        if(finishedLoading && navigationAction.navigationType == .other) {
            if let navUrl = navigationAction.request.url {
                listener?(placementId, SAEvent.adClicked)
                UIApplication.shared.open(navUrl)
            }
        }
        return nil
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        finishedLoading = true
    }
}
