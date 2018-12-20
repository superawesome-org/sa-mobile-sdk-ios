//
//  SAVideoEvents.swift
//  SuperAwesome
//
//  Created by Gabriel Coman on 17/12/2018.
//

import Foundation
import SAEvents
import SAModelSpace
import SASession

@objc(SAVideoEvents) class VideoEvents: NSObject, MediaControlDelegate {
    
    var events: SAEvents!
    
    var placementId: Int = 0
    var callback: sacallback? = nil
    
    private var isStartHandled: Bool = false
    private var is2SHandled: Bool = false
    private var isFirstQuartileHandled: Bool = false
    private var isMidpointHandled: Bool = false
    private var isThirdQuartileHandled: Bool = false
    
    weak var videoPlayer: AwesomeVideoPlayer?
    
    @objc(resetWithPlacementId:andAd:andSession:andMoatLimiting:)
    func reset(placementId: Int,
               ad: SAAd,
               session: SASession,
               isMoatLimitingEnabled: Bool) {
        
        self.placementId = placementId
        
        events = SAEvents()
        events?.setAd(ad, andSession: session)
        if (!isMoatLimitingEnabled) {
            events?.disableMoatLimiting()
        }
        
        isStartHandled = false
        is2SHandled = false
        isFirstQuartileHandled = false
        isMidpointHandled = false
        isThirdQuartileHandled = false
    }
    
    @objc(setVideoPlayer:)
    public func setVideoPlayer(player: AwesomeVideoPlayer) {
        videoPlayer = player
    }
    
    @objc(setCallback:)
    public func setCallback(_ callback: @escaping sacallback) {
        self.callback = callback
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // MediaControlDelegate
    ////////////////////////////////////////////////////////////////////////////
    
    public func didPrepare(control: MediaControl, item: AVPlayerItem) {
        if let videoPlayer = videoPlayer,
           let player = videoPlayer.getPlayer(),
           let playerLayer = videoPlayer.getLayer() {
           events?.startMoatTracking(forVideoPlayer: player,
                                     with: playerLayer,
                                     andView: videoPlayer)
        }
    }
    
    public func didUpdateTime(control: MediaControl, time: Int, duration: Int) {
        if (time >= 1 && !isStartHandled) {
            isStartHandled = true
            events?.triggerVASTImpressionEvent()
            events?.triggerVASTCreativeViewEvent()
            events?.triggerVASTStartEvent()
            callback?(placementId, SAEvent.adShown)
        }
        if (time >= 2 && !is2SHandled) {
            is2SHandled = true
            if let videoPlayer = videoPlayer,
               let value = events?.isChild(inViewableRect: videoPlayer),
                value == true {
                events?.triggerViewableImpressionEvent()
            }
        }
        if (time >= duration / 4 && !isFirstQuartileHandled) {
            isFirstQuartileHandled = true
            events?.triggerVASTFirstQuartileEvent()
        }
        if (time >= duration / 2 && !isMidpointHandled) {
            isMidpointHandled = true
            events?.triggerVASTMidpointEvent()
        }
        if (time >= (3 * duration) / 4 && !isThirdQuartileHandled) {
            isThirdQuartileHandled = true
            events?.triggerVASTThirdQuartileEvent()
        }
    }
    
    public func didCompleteMedia(control: MediaControl, time: Int, duration: Int) {
        events?.triggerVASTCompleteEvent()
        events?.stopMoatTrackingForVideoPlayer()
        callback?(placementId, SAEvent.adEnded)
    }
    
    public func didCompleteSeek(control: MediaControl) {
        // N/A
    }
    
    public func didError(control: MediaControl, error: Error, time: Int, duration: Int) {
        // N/A
    }
}
