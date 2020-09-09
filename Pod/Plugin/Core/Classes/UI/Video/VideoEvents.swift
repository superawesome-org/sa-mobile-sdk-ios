//
//  SAVideoEvents.swift
//  SuperAwesome
//
//  Created by Gabriel Coman on 18/01/2019.
//

import Foundation
import SAVideoPlayer

@objc (SAVideoEventsDelegate) public protocol VideoEventsDelegate: class {
    func hasBeenVisible()
}

class VideoEvents: Injectable {
    
    private var vastRepository: VastEventRepositoryType?

    private var isStartHandled: Bool = false
    private var is2SHandled: Bool = false
    private var isFirstQuartileHandled: Bool = false
    private var isMidpointHandled: Bool = false
    private var isThirdQuartileHandled: Bool = false
        
    public weak var delegate: VideoEventsDelegate?
    
    init(_ adResponse: AdResponse) {
        vastRepository = dependencies.resolve(param: adResponse) as VastEventRepositoryType
    }
    
    // MARK: - public class interface
    
    public func prepare(player: VideoPlayer, time: Int, duration: Int) {
        if let videoPlayer = player as? UIView,
           let avPlayer = player.getAVPlayer(),
           let avLayer = player.getAVPlayerLayer() {
//            events.startMoatTracking(forVideoPlayer: avPlayer,
//                                     with: avLayer,
//                                    andView: videoPlayer)
        }
    }
    
    public func complete(player: VideoPlayer, time: Int, duration: Int) {
//        events.stopMoatTrackingForVideoPlayer()
        guard time >= duration else { return }
        vastRepository?.complete()
    }
    
    public func error(player: VideoPlayer, time: Int, duration: Int) {
//        events.stopMoatTrackingForVideoPlayer()
        vastRepository?.error()
    }
    
    public func time(player: VideoPlayer, time: Int, duration: Int) {
        if (time >= 1 && !isStartHandled) {
            isStartHandled = true
            vastRepository?.impression()
            vastRepository?.creativeView()
            vastRepository?.start()
        }
        if (time >= 2 && !is2SHandled) {
            is2SHandled = true
            //events.isChild(inViewableRect: videoPlayer) == true
            if let videoPlayer = player as? UIView {
                vastRepository?.impression()
                delegate?.hasBeenVisible()
            }
        }
        if (time >= duration / 4 && !isFirstQuartileHandled) {
            isFirstQuartileHandled = true
            vastRepository?.firstQuartile()
        }
        if (time >= duration / 2 && !isMidpointHandled) {
            isMidpointHandled = true
            vastRepository?.midPoint()
        }
        if (time >= (3 * duration) / 4 && !isThirdQuartileHandled) {
            isThirdQuartileHandled = true
            vastRepository?.thirdQuartile()
        }
    }
}
