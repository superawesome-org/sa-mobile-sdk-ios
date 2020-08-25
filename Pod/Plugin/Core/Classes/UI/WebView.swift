//
//  WebView.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 24/08/2020.
//

import WebKit


class WebView: WKWebView {
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        configureScrollView()
    }
    
    func loadHTML(_ html: String?, witBase base: String?) {
        print("WebView.loadHTML called")
        // embed html code inside a full html wrapper
        let baseHtml = "<html><head><meta name=\"viewport\" content=\"width=device-width initial-scale=1\" /><style>html, body, div { margin: 0px; padding: 0px; } html, body { width:100%; height:100%; } </style></head><body>\(html ?? "")</body></html>"

        // lock-and-load
        if let data = baseHtml.data(using: .utf8), let url = URL(string: base ?? "") {
            load(data, mimeType: "text/html", characterEncodingName: "UTF-8", baseURL: url)
        }
    }
    
//    init(frame: CGRect) {
//        super.init(frame: frame)
//        configureScrollView()
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureScrollView() {
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        scrollView.bounces = false
    }
    
    /**
    * "defaultConfiguration" Returns the default web player configuration,
    * to be used when initialising this web view
    *
    * @return  default configuration for the web player
    */
    class func defaultConfiguration() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        return configuration
    }
}

extension WebView: UIScrollViewDelegate {
    /**
     * Overridden "viewForZoomingInScrollView:" method from the
     * UIScrollViewDelegate protocol
     *
     * @param scrollView    the current scroll view of the web view
     * @return              a scrolled zoomed UIView; or nil in this case
     */
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { nil }
}
