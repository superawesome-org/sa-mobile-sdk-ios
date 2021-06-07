//
//  MoatRepository.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 21/10/2020.
//

import WebKit
import AVFoundation

protocol MoatRepositoryType {
    func startMoatTracking(forDisplay webView: WKWebView?) -> String?

    func stopMoatTrackingForDisplay() -> Bool

    func startMoatTracking(forVideoPlayer player: AVPlayer?, with layer: AVPlayerLayer?, andView view: UIView?) -> Bool

    func stopMoatTrackingForVideoPlayer() -> Bool
}

class DefaultMoatRepository: MoatRepositoryType {
    func startMoatTracking(forDisplay webView: WKWebView?) -> String? {
        nil
    }

    func stopMoatTrackingForDisplay() -> Bool {
        false
    }

    func startMoatTracking(forVideoPlayer player: AVPlayer?, with layer: AVPlayerLayer?, andView view: UIView?) -> Bool {
        false
    }

    func stopMoatTrackingForVideoPlayer() -> Bool {
        false
    }
}
