//
//  UserAgentProvider.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 01/04/2020.
//

import WebKit

/**
* Class that provides the current User Agent using WKWebView object.
*/
protocol UserAgentProviderType {
    var name: String { get }
}

class UserAgentProvider : UserAgentProviderType {
    public var name: String
    private var webView: WKWebView?
    private var dataRepository: DataRepositoryType
    
    init(device:DeviceType, dataRepository: DataRepositoryType) {
        self.dataRepository = dataRepository
        self.name = dataRepository.userAgent ?? device.userAgent
        evaluateUserAgent()
    }
    
    private func evaluateUserAgent() {
        webView = WKWebView()
        webView?.evaluateJavaScript("navigator.userAgent", completionHandler: { (result, error) in
            if error != nil {
                print("UserAgent.evaluateUserAgent.error:", String(describing: error))
            } else if let result = result as! String? {
                self.name = result
                self.dataRepository.userAgent = result
            }
            
            self.webView = nil
        })
    }
}
