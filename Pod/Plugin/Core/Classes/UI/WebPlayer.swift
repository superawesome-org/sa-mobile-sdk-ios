//
//  WebPlayer.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 21/08/2020.
//

import UIKit
import WebKit

enum WebPlayerEvent: Int {
    case start = 0
    case error = 1
}

class WebPlayer: UIView {
    private var webView: WebView?
    
    override func removeFromSuperview() {
        unregisterForOrientationDidChangeNotification()
        super.removeFromSuperview()
    }
    
//    convenience init?( contentSize: CGSize, andParentFrame parentRect: CGRect ) {
//
//    }
}
