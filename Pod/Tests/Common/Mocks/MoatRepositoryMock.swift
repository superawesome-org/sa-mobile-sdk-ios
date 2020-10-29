//
//  MoatRepositoryMock.swift
//  SuperAwesome-Unit-Full-Tests
//
//  Created by Gunhan Sancar on 28/10/2020.
//

import WebKit
import AVKit
@testable import SuperAwesome

struct MoatRepositoryMock: MoatRepositoryType {
    func startMoatTracking(forDisplay webView: WKWebView?) -> String? {
        ""
    }
    
    func stopMoatTrackingForDisplay() -> Bool {
        true
    }
    
    func startMoatTracking(forVideoPlayer player: AVPlayer?, with layer: AVPlayerLayer?, andView view: UIView?) -> Bool {
        true
    }
    
    func stopMoatTrackingForVideoPlayer() -> Bool {
        true
    }
    
    
}
