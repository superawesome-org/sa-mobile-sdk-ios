//
//  VideoViewController.swift
//  SuperAwesome
//
//  Created by Gabriel Coman on 17/12/2018.
//

import UIKit
import SAVideoPlayer


@objc(SAVideoViewController) class VideoViewController: UIViewController, Injectable {
    
    private lazy var controller: AdControllerType = dependencies.resolve()
    private lazy var orientationProvider: OrientationProviderType = dependencies.resolve()
    
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
        let orientation: Orientation
    }
    
    private let config: Config
    private let control: VideoPlayerControls = VideoPlayerController()
    private let videoEvents: VideoEvents
    
    private var callback: AdEventCallback? = nil
    
    init(adResponse: AdResponse, callback: AdEventCallback?, config: Config) {
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
        view.backgroundColor = UIColor.black
        view.layoutMargins = UIEdgeInsets.zero
        
        // setup video player
        videoPlayer = AwesomeVideoPlayer()
        videoPlayer.setControls(controller: control)
        videoPlayer.layoutMargins = UIEdgeInsets.zero
        videoPlayer.setDelegate(delegate: self)
        view.addSubview(videoPlayer)
        videoPlayer.bind(toTheEdgesOf: view)
        
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
            self?.controller.handleSafeAdTap()
        }
        videoPlayer.setControlsView(controllerView: chrome)
        chrome.bind(toTheEdgesOf: videoPlayer)
        
        // play ad
        if let url = controller.filePathUrl {
            control.play(url: url)
        }
        
        // register notification for foreground
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main)
        { [weak self] notification in
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
    
    @objc
    func willEnterForeground(_ notification: Notification) -> Void {
        control.start()
    }
    ////////////////////////////////////////////////////////////////////////////
    // private methods
    ////////////////////////////////////////////////////////////////////////////
    
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
