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

@objc(SAClickVideoEventsDelegate) protocol ClickVideoEventsDelegate {
    @objc(didClickOnPlacementId:)
    func didClickOn(placementId: Int)
}

@objc(SAClickVideoEvents) class ClickVideoEvents: NSObject {
    
    private static let PADLOCK_URL = "https://ads.superawesome.tv/v2/safead"
    
    private var placementId: Int = 0
    private var events: SAEvents!
    private var isParentalGateEnabled: Bool = false
    private var isBumperPageEnabled: Bool = false
    
    private var currentClickThreshold: TimeInterval = 0
    
    private let delegate: ClickVideoEventsDelegate
    
    @objc(initWithDelegate:)
    init(withDelegate delegate: ClickVideoEventsDelegate) {
        self.delegate = delegate
        super.init()
    }
    
    @objc(resetWithPlacementId:andEvents:andParentalGate:andBumperPage:)
    func reset(placementId: Int,
               events: SAEvents,
               isParentalGateEnabled: Bool,
               isBumperPageEnabled: Bool) {
        self.placementId = placementId
        self.events = events
        self.isParentalGateEnabled = isParentalGateEnabled
        self.isBumperPageEnabled = isBumperPageEnabled
    }
    
    func didTapOnPadlock() {
        if let url = URL(string: ClickVideoEvents.PADLOCK_URL) {
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
        
        delegate.didClickOn(placementId: placementId)
        events.triggerVASTClickTrackingEvent()
        if let url = URL(string: destination) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
