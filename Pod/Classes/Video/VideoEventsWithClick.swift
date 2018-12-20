//
//  VideoEventsWithClick.swift
//  SuperAwesome
//
//  Created by Gabriel Coman on 19/12/2018.
//

import UIKit
import SAModelSpace
import SAEvents
import SAParentalGate
import SABumperPage

@objc(VideoEventsWithClick) class VideoEventsWithClick: VideoEvents, AdChromeControlDelegate {
    
    private static let PADLOCK_URL = "https://ads.superawesome.tv/v2/safead"
    
    private var isParentalGateEnabled: Bool = false
    private var isBumperPageEnabled: Bool = false
    
    private var currentClickThreshold: TimeInterval = 0
    
    @objc(resetWithPlacementId:andAd:andSession:andMoatLimiting:andParentalGate:andBumperPage:)
    func reset(placementId: Int,
               ad: SAAd,
               session: SASession,
               isMoatLimitingEnabled: Bool,
               isParentalGateEnabled: Bool,
               isBumperPageEnabled: Bool) {
        super.reset(placementId: placementId,
                    ad: ad,
                    session: session,
                    isMoatLimitingEnabled: isMoatLimitingEnabled)
        self.isParentalGateEnabled = isParentalGateEnabled
        self.isBumperPageEnabled = isBumperPageEnabled
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // AdChromeControlDelegate
    ////////////////////////////////////////////////////////////////////////////
    
    func didTapOnPadlock() {
        if let url = URL(string: VideoEventsWithClick.PADLOCK_URL) {
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
        
        callback?(placementId, SAEvent.adClicked)
        events.triggerVASTClickTrackingEvent()
        if let url = URL(string: destination) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func didStartProgressBarSeek() { /* N/A */ }
    
    func didEndProgressBarSeek(value: Float) { /* N/A */ }
    
    func didTapPlay()  { /* N/A */ }
    
    func didTapPause()  { /* N/A */ }
    
    func didTapReplay()  { /* N/A */ }
    
    func didTapMaximise()  { /* N/A */ }
    
    func didTapMinimise()  { /* N/A */ }
    
    func didTapClose() {
        videoPlayer?.destroy()
        SAParentalGate.close()
    }
}
