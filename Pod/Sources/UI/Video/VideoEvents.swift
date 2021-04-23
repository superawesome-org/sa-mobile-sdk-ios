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
    private var moatRepository: MoatRepositoryType?
    private var viewableDetector: ViewableDetectorType?

    private var isStartHandled: Bool = false
    private var is2SHandled: Bool = false
    private var isFirstQuartileHandled: Bool = false
    private var isMidpointHandled: Bool = false
    private var isThirdQuartileHandled: Bool = false
    private var totalTime = 0

    public weak var delegate: VideoEventsDelegate?

    init(_ adResponse: AdResponse) {
        vastRepository = dependencies.resolve(param: adResponse) as VastEventRepositoryType
        moatRepository = dependencies.resolve(param: adResponse, false) as MoatRepositoryType
    }

    // MARK: - public class interface

    public func prepare(player: VideoPlayer, time: Int, duration: Int) {
        if let videoPlayer = player as? UIView,
           let avPlayer = player.getAVPlayer(),
           let avLayer = player.getAVPlayerLayer() {
            _ = moatRepository?.startMoatTracking(forVideoPlayer: avPlayer,
                                              with: avLayer,
                                              andView: videoPlayer)
        }
    }

    public func complete(player: VideoPlayer, time: Int, duration: Int) {
        _ = moatRepository?.stopMoatTrackingForVideoPlayer()
        guard time >= duration else { return }
        vastRepository?.complete()
    }

    public func error(player: VideoPlayer, time: Int, duration: Int) {
        _ = moatRepository?.stopMoatTrackingForVideoPlayer()
        vastRepository?.error()
    }

    public func time(player: VideoPlayer, time: Int, duration: Int) {
        totalTime += time
        if totalTime >= 1 && !isStartHandled {
            isStartHandled = true
            vastRepository?.impression()
            vastRepository?.creativeView()
            vastRepository?.start()
        }
        if totalTime >= 2 && !is2SHandled {
            is2SHandled = true

            if let videoPlayer = player as? UIView {
                viewableDetector = dependencies.resolve() as ViewableDetectorType
                viewableDetector?.start(for: videoPlayer, hasBeenVisible: { [weak self] in
                    self?.vastRepository?.impression()
                    self?.delegate?.hasBeenVisible()
                })
            }
        }
        if totalTime >= duration / 4 && !isFirstQuartileHandled {
            isFirstQuartileHandled = true
            vastRepository?.firstQuartile()
        }
        if totalTime >= duration / 2 && !isMidpointHandled {
            isMidpointHandled = true
            vastRepository?.midPoint()
        }
        if totalTime >= (3 * duration) / 4 && !isThirdQuartileHandled {
            isThirdQuartileHandled = true
            vastRepository?.thirdQuartile()
        }
    }

    deinit {
        viewableDetector = nil
    }
}
