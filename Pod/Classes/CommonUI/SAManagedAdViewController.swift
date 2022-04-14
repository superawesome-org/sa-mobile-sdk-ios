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
    private lazy var imageProvider: ImageProviderType = dependencies.resolve()

    init(placementId: Int, html: String, callback: AdEventCallback?) {
        self.placementId = placementId
        self.html = html
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't use this externally!")
    }

    lazy var managedAdView: SAManagedAdView = {
        let adView = SAManagedAdView()
        adView.setBridge(bridge: self)
        adView.setCallback(value: callback)
        return adView
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        initView()

        DispatchQueue.main.async {
            self.managedAdView.load(placementId: self.placementId, html: self.html)
        }

    }

    /// Method that is called to close the ad
    func close() {
        managedAdView.close()

        dismiss(animated: true, completion: nil)
    }

    private func configureCloseButton() {
        let button = UIButton()
        button.isHidden = false
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
}

extension SAManagedAdViewController: AdViewJavaScriptBridge {
    func onEvent(event: AdEvent) {
        callback?(self.placementId, event)

        if eventsForClosing.contains(event) {
            if !isBeingDismissed {
                close()
            }
        }
    }
}

private let eventsForClosing = [
    AdEvent.adEmpty, .adFailedToLoad, .adFailedToShow, .adEnded, .adClosed
]
