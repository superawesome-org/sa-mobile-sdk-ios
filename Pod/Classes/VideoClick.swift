//
//  VideoClick.swift
//  SuperAwesome
//
//  Created by Gabriel Coman on 18/12/2018.
//

import UIKit
import SAEvents
import SAParentalGate
import SABumperPage

@objc(SAVideoClick) class VideoClick: NSObject, AdChromeControlDelegate {
    
    private static let PADLOCK_URL = "https://ads.superawesome.tv/v2/safead"
    
    private let events: SAEvents
    private let isParentalGateEnabled: Bool
    private let isBumperPageEnabled: Bool
    
    private var currentClickThreshold: TimeInterval = 0
    
    private let placementId: Int
    
    @objc(initWithEvents:andPlacementId:andParentalGateEnabled:andBumperEnabled:)
    init(events: SAEvents,
         placementId: Int,
         isParentalGateEnabled: Bool,
         isBumperPageEnabled: Bool) {
        self.placementId = placementId
        self.isParentalGateEnabled = isParentalGateEnabled
        self.isBumperPageEnabled = isBumperPageEnabled
        self.events = events
        super.init()
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // AdChromeControlDelegate
    ////////////////////////////////////////////////////////////////////////////
    
    func didTapOnPadlock() {
        if let url = URL(string: VideoClick.PADLOCK_URL) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func didTapOnSurface() {
        if let destination = events.getVASTClickThroughEvent() {
            if isParentalGateEnabled {
                SAParentalGate.setPgOpenCallback {
                    self.events.triggerPgOpenEvent()
                }
                SAParentalGate.setPgCanceledCallback {
                    self.events.triggerPgCloseEvent()
                }
                SAParentalGate.setPgFailedCallback {
                    self.events.triggerPgFailEvent()
                }
                SAParentalGate.setPgSuccessCallback {
                    self.events.triggerPgSuccessEvent()
                    self.click(destination: destination)
                }
                SAParentalGate.play()
            }
            else {
                click(destination: destination)
            }
        }
    }
    
    private func click(destination: String) {
        if isBumperPageEnabled {
            SABumperPage.setCallback {
                self.handleUrl(destination: destination)
            }
            SABumperPage.play()
        }
        else {
            handleUrl(destination: destination)
        }
    }
    
    private func handleUrl(destination: String) {
     
        let currentTime = NSDate().timeIntervalSince1970
        let diff = abs(currentTime - currentClickThreshold)
        
        if Int32(diff) < SA_DEFAULT_CLICK_THRESHOLD {
            return
        }
        
        currentClickThreshold = currentTime
        
        let callback: sacallback? = VideoAd.getCallbac()
        callback?(placementId, SAEvent.adClicked)
        events.triggerVASTClickTrackingEvent()
        if let url = URL(string: destination) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
