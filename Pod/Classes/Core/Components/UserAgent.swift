//
//  WebAgent.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 01/04/2020.
//

import WebKit

@objc(SAUserAgentType)
public protocol UserAgentType {
    @objc(name) var name: String { get }
}

@objc(SAUserAgent)
public class UserAgent : NSObject, UserAgentType {
    @objc(shared)
    @available(*, deprecated, message: "Temporary code to help out legac code. Refactor to not be a singleton")
    public static let shared: UserAgentType = UserAgent(device: Device(), dataRepository: DataRepository())
    
    public var name: String
    private var webView: WKWebView?
    private var dataRepository: DataRepositoryType
    
    public init(device:DeviceType, dataRepository: DataRepositoryType) {
        self.dataRepository = dataRepository
        self.name = dataRepository.userAgent ?? device.userAgent
        super.init()
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
