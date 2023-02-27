//
//  SAManagedVideoAd.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 12/01/2022.
//

import UIKit
import WebKit

@objc(SAManagedAdViewController) public final class SAManagedAdViewController: UIViewController, Injectable {
    private let placementId: Int
    private let html: String
    private var closeButton: UIButton?
    private var callback: AdEventCallback?
    private weak var closeButtonFallbackTimer: Timer?
    private var closeButtonFallbackTimerTickCounter = 0
    private let config: AdConfig
    private lazy var imageProvider: ImageProviderType = dependencies.resolve()
    private lazy var controller: AdControllerType = dependencies.resolve()
    private lazy var viewableDetector: ViewableDetectorType? = dependencies.resolve() as ViewableDetectorType

    init(adResponse: AdResponse, config: AdConfig, callback: AdEventCallback?) {
        self.placementId = adResponse.placementId
        self.html = adResponse.advert.creative.details.tag ?? ""
        self.callback = callback
        self.config = config
        super.init(nibName: nil, bundle: nil)
        self.controller.adResponse = adResponse
        self.controller.parentalGateEnabled = config.isParentalGateEnabled
        self.controller.bumperPageEnabled = config.isBumperPageEnabled
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't use this externally!")
    }

    lazy var managedAdView: SAManagedAdView = {
        let adView = SAManagedAdView()
        adView.accessibilityIdentifier = "adContent"
        adView.setBridge(bridge: self)
        adView.setCallback(value: callback)
        return adView
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        initView()

        DispatchQueue.main.async {
            self.managedAdView.load(placementId: self.placementId,
                                    html: self.html,
                                    baseUrl: self.controller.adResponse?.baseUrl)
        }

    }

    /// Method that is called to close the ad
    func close() {
        managedAdView.close()
        controller.close()

        dismiss(animated: true, completion: nil)
    }

    private func configureCloseButton() {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(imageProvider.closeImage, for: .normal)
        button.addTarget(self, action: #selector(onCloseClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 40.0),
            button.heightAnchor.constraint(equalToConstant: 40.0),
            button.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: 0),
            button.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 0)
        ])

        self.closeButton = button

        switch config.closeButtonState {
        case .visibleWithDelay:
            button.isHidden = true
            closeButtonFallbackTimer = Timer.scheduledTimer(timeInterval: 1,
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

    private func showCloseButtonAfterDelay() {

        cancelCloseButtonVisibilityFallback()

        viewableDetector?.start(for: managedAdView, hasBeenVisible: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.closeButton?.isHidden = false
        })
    }

    @objc private func closeButtonVisibilityFallback() {
        closeButtonFallbackTimerTickCounter += 1
        if closeButtonFallbackTimerTickCounter >= config.closeButtonFallbackDelay {
            cancelCloseButtonVisibilityFallback()
            closeButton?.isHidden = false
        }
    }

    private func cancelCloseButtonVisibilityFallback() {
        closeButtonFallbackTimerTickCounter = 0
        closeButtonFallbackTimer?.invalidate()
        closeButtonFallbackTimer = nil
    }

    @objc private func onCloseClicked() {
        managedAdView.close()
        dismiss(animated: true)
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

        configureCloseButton()
    }

    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cancelCloseButtonVisibilityFallback()
    }
}

extension SAManagedAdViewController: AdViewJavaScriptBridge {
    func onEvent(event: AdEvent) {
        callback?(self.placementId, event)

        if (event == .adShown && config.closeButtonState == .visibleWithDelay) {
            showCloseButtonAfterDelay()
        }

        if eventsForClosing.contains(event) {
            if !isBeingDismissed {
                close()
            }
        }
    }

    func onAdClick(url: URL) {
        callback?(placementId, .adClicked)
        controller.handleAdTap(url: url)
    }
}

private let eventsForClosing = [
    AdEvent.adEmpty, .adFailedToLoad, .adFailedToShow, .adEnded, .adClosed
]
