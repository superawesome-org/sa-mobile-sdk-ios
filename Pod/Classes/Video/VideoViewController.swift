//
//  VideoViewController.swift
//  SuperAwesome
//
//  Created by Gabriel Coman on 17/12/2018.
//

import UIKit

@objc(SAVideoViewController) class VideoViewController: UIViewController, VideoPlayerDelegate, VideoEventsDelegate, Injectable {

    ////////////////////////////////////////////////////////////////////////////
    // SubViews
    ////////////////////////////////////////////////////////////////////////////

    private var videoPlayer: AwesomeVideoPlayer!
    private var chrome: AdSocialVideoPlayerControlsView!

    ////////////////////////////////////////////////////////////////////////////
    // Custom values
    ////////////////////////////////////////////////////////////////////////////

    struct Config {
        let showSmallClick: Bool
        let showSafeAdLogo: Bool
        let showCloseButton: Bool
        let shouldCloseAtEnd: Bool
        let isParentalGateEnabled: Bool
        let isBumperPageEnabled: Bool
        let orientation: SAOrientation
    }

    private let ad: SAAd
    private let events: SAEvents
    private let config: Config
    private let control: VideoPlayerControls = VideoPlayerController()
    private let videoEvents: VideoEvents
    private let clickEvents: VideoClick

    private var callback: AdEventCallback?

    private var logger: LoggerType = dependencies.resolve(param: VideoViewController.self)

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }

    @available(iOS 11.0, *)
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        guard let supportedOrientations = Bundle.main.infoDictionary?["UISupportedInterfaceOrientations"] as? [String]
        else { return super.supportedInterfaceOrientations }

        switch config.orientation {
        case .ANY:
            return super.supportedInterfaceOrientations
        case .PORTRAIT:
            let hasPortrait = supportedOrientations.contains("UIInterfaceOrientationPortrait")
            let hasPortraitUpsideDown = supportedOrientations.contains("UIInterfaceOrientationPortraitUpsideDown")

            if hasPortrait && hasPortraitUpsideDown {
                return [.portrait, .portraitUpsideDown]
            } else if hasPortrait {
                return .portrait
            } else if hasPortraitUpsideDown {
                return .portraitUpsideDown
            } else {
                return super.supportedInterfaceOrientations
            }
        case .LANDSCAPE:
            let hasLandscapeLeft = supportedOrientations.contains("UIInterfaceOrientationLandscapeLeft")
            let hasLandscapeRight = supportedOrientations.contains("UIInterfaceOrientationLandscapeRight")

            if hasLandscapeLeft && hasLandscapeRight {
                return .landscape
            } else if hasLandscapeLeft {
                return .landscapeLeft
            } else if hasLandscapeRight {
                return .landscapeRight
            } else {
                return super.supportedInterfaceOrientations
            }
        }
    }

    init(withAd ad: SAAd,
         andEvents events: SAEvents,
         andCallback callback: AdEventCallback?,
         andConfig config: Config) {
        self.ad = ad
        self.events = events
        self.config = config
        self.callback = callback
        videoEvents = VideoEvents(events: events)
        clickEvents = VideoClick(events: events,
                                 isParentalGateEnabled: config.isParentalGateEnabled,
                                 isBumperPageEnabled: config.isBumperPageEnabled)
        super.init(nibName: nil, bundle: nil)
        videoEvents.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't use this externally!")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // initial view setup
        view.backgroundColor = UIColor.black
        view.layoutMargins = UIEdgeInsets.zero

        // setup video player
        videoPlayer = AwesomeVideoPlayer()
        videoPlayer.setControls(controller: control)
        videoPlayer.layoutMargins = UIEdgeInsets.zero
        videoPlayer.setDelegate(delegate: self)
        view.addSubview(videoPlayer)
        LayoutUtils.bind(view: videoPlayer, toTheEdgesOf: view)

        // setup chrome
        chrome = AdSocialVideoPlayerControlsView(smallClick: config.showSmallClick, showSafeAdLogo: config.showSafeAdLogo)
        chrome.layoutMargins = UIEdgeInsets.zero
        chrome.setCloseAction { [weak self] in
            self?.closeAction()
        }
        chrome.setClickAction { [weak self] in
            self?.clickAction()
        }
        chrome.setPadlockAction { [weak self] in
            self?.clickEvents.handleSafeAdTap()
        }
        videoPlayer.setControlsView(controllerView: chrome)
        LayoutUtils.bind(view: chrome, toTheEdgesOf: videoPlayer)

        // play ad
        if let diskUrl = SAUtils.filePath(inDocuments: ad.creative.details.media.path) {
            let url = URL(fileURLWithPath: diskUrl)
            control.play(url: url)
        }

        // register notification for foreground
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [weak self] notification in
            self?.willEnterForeground(notification)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        control.start()
    }

    override func viewWillDisappear(_ animated: Bool) {
        control.pause()
        super.viewWillDisappear(animated)
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.willEnterForegroundNotification,
                                                  object: nil)
    }

    ////////////////////////////////////////////////////////////////////////////
    // Foreground
    ////////////////////////////////////////////////////////////////////////////

    func willEnterForeground(_ notification: Notification) {
        control.start()
    }

    ////////////////////////////////////////////////////////////////////////////
    // VideoPlayerDelegate
    ////////////////////////////////////////////////////////////////////////////

    func didPrepare(videoPlayer: VideoPlayer, time: Int, duration: Int) {
        videoEvents.prepare(player: videoPlayer, time: time, duration: duration)
        callback?(ad.placementId, .adShown)
    }

    func didUpdateTime(videoPlayer: VideoPlayer, time: Int, duration: Int) {
        videoEvents.time(player: videoPlayer, time: time, duration: duration)
    }

    func didComplete(videoPlayer: VideoPlayer, time: Int, duration: Int) {
        videoEvents.complete(player: videoPlayer, time: time, duration: duration)
        chrome.makeCloseButtonVisible()
        callback?(ad.placementId, .adEnded)
        logger.info("Event callback: adEnded for placement \(ad.placementId)")

        if config.shouldCloseAtEnd {
            closeAction()
        }
    }

    func didError(videoPlayer: VideoPlayer, error: Error, time: Int, duration: Int) {
        videoEvents.error(player: videoPlayer, time: time, duration: duration)
        callback?(ad.placementId, .adFailedToShow)
        closeAction()
    }

    func hasBeenVisible() {
        if config.showCloseButton {
            chrome.makeCloseButtonVisible()
        }
    }

    ////////////////////////////////////////////////////////////////////////////
    // private methods
    ////////////////////////////////////////////////////////////////////////////

    private func clickAction() {
        callback?(ad.placementId, .adClicked)
        logger.info("Event callback: adClicked for placement \(ad.placementId)")
        clickEvents.handleAdTap()
    }

    private func closeAction() {
        videoPlayer.destroy()
        SAParentalGate.close()
        dismiss(animated: true) { [weak self] in
            if let placementId = self?.ad.placementId {
                self?.callback?(placementId, .adClosed)
                self?.logger.info("Event callback: adClosed for placement \(placementId)")
            }
        }
    }
}
