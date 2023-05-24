//
//  SAManagedVideoAd.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 12/01/2022.
//

import UIKit
import WebKit

@objc(SAManagedAdViewController) public final class SAManagedAdViewController: UIViewController, Injectable, AdControllerVideoDelegate {

    // MARK: Properties

    private let accessibilityPrefix = "SuperAwesome.ManagedAdView."
    private let placementId: Int
    private let html: String
    private let config: AdConfig
    private let closeButtonSize: CGFloat = 40.0

    private let eventsForClosing = [
        AdEvent.adEmpty, .adFailedToLoad, .adFailedToShow, .adClosed
    ]

    private var closeButton: UIButton?
    private var closeButtonFallbackTimerTickCounter = 0
    private var callback: AdEventCallback?
    private var isCompleted: Bool = false
    private var closeDialog: UIAlertController?

    private weak var closeButtonFallbackTimer: Timer?
    private lazy var stringProvider: StringProviderType = dependencies.resolve()
    private lazy var imageProvider: ImageProviderType = dependencies.resolve()
    private lazy var controller: AdControllerType = dependencies.resolve()
    private lazy var viewableDetector: ViewableDetectorType? = dependencies.resolve() as ViewableDetectorType
    private lazy var environment: Environment = dependencies.resolve() as Environment
    private lazy var logger: LoggerType = dependencies.resolve(param: SAManagedAdViewController.self)

    // MARK: Init

    init(adResponse: AdResponse, config: AdConfig, callback: AdEventCallback?) {
        self.placementId = adResponse.placementId
        self.html = adResponse.html ?? ""
        self.callback = callback
        self.config = config
        super.init(nibName: nil, bundle: nil)
        controller.adResponse = adResponse
        controller.parentalGateEnabled = config.isParentalGateEnabled
        controller.bumperPageEnabled = config.isBumperPageEnabled
        controller.callback = callback
        controller.videoDelegate = self
        view.accessibilityIdentifier = "\(accessibilityPrefix)Screen"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't use this externally!")
    }

    lazy var managedAdView: SAManagedAdView = {
        let adView = SAManagedAdView()
        adView.setDelegate(self)
        adView.setCallback(value: callback)
        return adView
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        initView()

        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.managedAdView.load(placementId: strongSelf.placementId,
                                          html: strongSelf.html,
                                          baseUrl: strongSelf.controller.adResponse?.baseUrl ?? self?.environment.baseURL.absoluteString)
        }

        // register notification for foreground
        // swiftlint:disable discarded_notification_center_observer
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification,
                                               object: nil,
                                               queue: .main) { [weak self] notification in
            self?.willEnterForeground(notification)
        }

        // register notification for background
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification,
                                               object: nil,
                                               queue: .main) { [weak self] _ in
            self?.didEnterBackground()
        }
        // swiftlint:enable discarded_notification_center_observer
    }

    /// Method that is called to close the ad
    func close() {
        managedAdView.close()
        controller.close()
        view.window?.rootViewController?.dismiss(animated: true)
    }

    private func configureCloseButton() {

        if closeButton != nil {
            closeButton?.removeFromSuperview()
            closeButton = nil
        }

        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(imageProvider.closeImage, for: .normal)
        button.addTarget(self, action: #selector(onCloseClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "\(accessibilityPrefix)Buttons.Close"
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: closeButtonSize),
            button.heightAnchor.constraint(equalToConstant: closeButtonSize),
            button.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: 0.0),
            button.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 0.0)
        ])

        self.closeButton = button

        switch config.closeButtonState {
        case .visibleWithDelay:
            button.isHidden = true
            closeButtonFallbackTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                                            target: self,
                                                            selector: #selector(closeButtonVisibilityFallback),
                                                            userInfo: nil,
                                                            repeats: true)
        case .visibleImmediately:
            button.isHidden = false
        case .hidden:
            button.isHidden = true
        }
    }
    
    private func showCloseButton() {
        closeButton?.isHidden = false
    }

    private func showCloseButtonAfterDelay() {
        cancelCloseButtonVisibilityFallback()

        viewableDetector?.start(for: managedAdView, hasBeenVisible: { [weak self] in
            self?.showCloseButton()
        })
    }

    @objc private func closeButtonVisibilityFallback() {
        closeButtonFallbackTimerTickCounter += 1
        if closeButtonFallbackTimerTickCounter >= config.closeButtonFallbackDelay {
            cancelCloseButtonVisibilityFallback()
            showCloseButton()
        }
    }

    private func cancelCloseButtonVisibilityFallback() {
        closeButtonFallbackTimerTickCounter = 0
        closeButtonFallbackTimer?.invalidate()
        closeButtonFallbackTimer = nil
    }

    @objc private func onCloseClicked() {
        if config.shouldShowCloseWarning && !isCompleted {
            managedAdView.pauseVideo()
            closeDialog = showQuestionDialog(title: stringProvider.closeDialogTitle,
                                             message: stringProvider.closeDialogMessage,
                                             yesTitle: stringProvider.closeDialogCloseAction,
                                             noTitle: stringProvider.closeDialogResumeAction) { [weak self] in
                self?.close()
            } noAction: { [weak self] in
                self?.managedAdView.playVideo()
            }
        } else {
            close()
        }
    }

    private func initView() {
        managedAdView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(managedAdView)

        NSLayoutConstraint.activate([
            managedAdView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 0),
            managedAdView.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: 0),
            managedAdView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: 0),
            managedAdView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 0)
        ])
        view.backgroundColor = .black
        configureCloseButton()
    }

    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cancelCloseButtonVisibilityFallback()
        viewableDetector?.cancel()
        viewableDetector = nil
    }

    // MARK: Background / Foreground handlers

    @objc
    func willEnterForeground(_ notification: Notification) {
        managedAdView.playVideo()
    }

    private func didEnterBackground() {
        managedAdView.pauseVideo()
        closeDialog?.dismiss(animated: true)
        closeDialog = nil
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.willEnterForegroundNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.didEnterBackgroundNotification,
                                                  object: nil)
    }
}

// MARK: SAManagedAdViewDelegate

extension SAManagedAdViewController: SAManagedAdViewDelegate {
    func onEvent(event: AdEvent) {
        logger.info("onEvent: \(event.name())")
        
        callback?(placementId, event)
        
        if event == .adShown && config.closeButtonState == .visibleWithDelay {
            showCloseButtonAfterDelay()
        }

        if event == .adEnded {
            isCompleted = true
            
            if config.shouldCloseAtEnd {
                dismiss()
            } else {
                showCloseButton()
            }
        } else if eventsForClosing.contains(event) {
            dismiss()
        }
    }

    private func dismiss() {
        if !isBeingDismissed {
            close()
        }
    }

    func onAdClick(url: URL) {
        callback?(placementId, .adClicked)
        controller.handleAdTap(url: url)
    }

    // MARK: AdControllerVideoDelegate

    public func controllerDidRequestPlayVideo() {
        managedAdView.playVideo()
    }

    public func controllerDidRequestPauseVideo() {
        managedAdView.pauseVideo()
    }
}
