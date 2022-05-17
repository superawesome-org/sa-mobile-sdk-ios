//
//  VideoViewController.swift
//  SuperAwesome
//
//  Created by Gabriel Coman on 17/12/2018.
//

import UIKit

@objc(SAVideoViewController) class VideoViewController: UIViewController, Injectable {

    private lazy var controller: AdControllerType = dependencies.resolve()
    private lazy var orientationProvider: OrientationProviderType = dependencies.resolve()
    private var videoPlayer: AwesomeVideoPlayer!
    private var chrome: AdSocialVideoPlayerControlsView!
    private var logger: LoggerType = dependencies.resolve(param: VideoViewController.self)
    private let config: AdConfig
    private let control: VideoPlayerControls = VideoPlayerController()
    private let videoEvents: VideoEvents

    private var callback: AdEventCallback?

    init(adResponse: AdResponse, callback: AdEventCallback?, config: AdConfig) {
        self.config = config
        self.callback = callback
        videoEvents = VideoEvents(adResponse)
        super.init(nibName: nil, bundle: nil)
        self.controller.adResponse = adResponse
        self.controller.parentalGateEnabled = config.isParentalGateEnabled
        self.controller.bumperPageEnabled = config.isBumperPageEnabled
        videoEvents.delegate = self
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    override var prefersStatusBarHidden: Bool { true }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { .fade }

    @available(iOS 11.0, *)
    override var prefersHomeIndicatorAutoHidden: Bool { true }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        orientationProvider.findSupportedOrientations(config.orientation, super.supportedInterfaceOrientations)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't use this externally!")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // initial view setup
        view.backgroundColor = .black
        view.layoutMargins = .zero

        // setup video player
        videoPlayer = AwesomeVideoPlayer()
        videoPlayer.setControls(controller: control)
        videoPlayer.layoutMargins = .zero
        videoPlayer.setDelegate(delegate: self)
        view.addSubview(videoPlayer)
        videoPlayer.bind(toTheEdgesOf: view)

        // setup chrome
        chrome = AdSocialVideoPlayerControlsView(smallClick: config.showSmallClick, showSafeAdLogo: config.showSafeAdLogo)
        chrome.layoutMargins = .zero
        chrome.setCloseAction { [weak self] in
            self?.closeAction()
        }
        chrome.setClickAction { [weak self] in
            self?.clickAction()
        }
        chrome.setPadlockAction { [weak self] in
            self?.controller.handleSafeAdTap()
        }
        videoPlayer.setControlsView(controllerView: chrome)
        chrome.bind(toTheEdgesOf: videoPlayer)

        // play ad
        if let url = controller.filePathUrl {
            control.play(url: url)
        }

        // register notification for foreground
        // swiftlint:disable discarded_notification_center_observer
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

    @objc
    func willEnterForeground(_ notification: Notification) {
        control.start()
    }

    private func clickAction() {
        controller.adClicked()
        controller.handleAdTapForVast()
    }

    private func closeAction() {
        videoPlayer.destroy()
        dismiss(animated: true) { [weak self] in
            self?.controller.close()
        }
    }
}

extension VideoViewController: VideoEventsDelegate {
    func hasBeenVisible() {
        controller.triggerViewableImpression()
        controller.triggerDwellTime()

        if config.showCloseButton {
            chrome.makeCloseButtonVisible()
        }
    }
}

extension VideoViewController: VideoPlayerDelegate {
    func didPrepare(videoPlayer: VideoPlayer, time: Int, duration: Int) {
        videoEvents.prepare(player: videoPlayer, time: time, duration: duration)
        controller.adShown()
    }

    func didUpdateTime(videoPlayer: VideoPlayer, time: Int, duration: Int) {
        videoEvents.time(player: videoPlayer, time: time, duration: duration)
    }

    func didComplete(videoPlayer: VideoPlayer, time: Int, duration: Int) {
        videoEvents.complete(player: videoPlayer, time: time, duration: duration)
        chrome.makeCloseButtonVisible()
        controller.adEnded()

        if config.shouldCloseAtEnd {
            closeAction()
        }
    }

    func didError(videoPlayer: VideoPlayer, error: Error, time: Int, duration: Int) {
        videoEvents.error(player: videoPlayer, time: time, duration: duration)
        controller.adFailedToShow()
        closeAction()
    }
}
