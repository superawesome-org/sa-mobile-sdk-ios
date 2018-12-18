//
//  VideoClick.swift
//  SuperAwesome
//
//  Created by Gabriel Coman on 18/12/2018.
//

import UIKit

@objc(SAVideoClick) class VideoClick: NSObject, AdChromeControlDelegate {
    
    private static let PADLOCK_URL = "https://ads.superawesome.tv/v2/safead"
    
    ////////////////////////////////////////////////////////////////////////////
    // AdChromeControlDelegate
    ////////////////////////////////////////////////////////////////////////////
    
    func didTapOnPadlock() {
        if let url = URL(string: VideoClick.PADLOCK_URL) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func didTapOnSurface() {
        
    }
}
