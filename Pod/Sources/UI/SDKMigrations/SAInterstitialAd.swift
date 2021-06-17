//
//  SAInterstitialAd.swift
//  mopub-ios-sdk
//
//  Created by Mark on 16/06/2021.
//

import Foundation

@available(*, deprecated, renamed: "InterstitialAd" )
public class SAInterstitialAd: InterstitialAd {
    private static var listener: SADelegate?


    @available(*, deprecated, renamed: "setCallback" )
    public static func setListener(listener: SADelegate) {
        self.listener = listener

        setCallback { _, adEvent in
            switch adEvent {
            case .adAlreadyLoaded: listener.onEvent(placementId: 1, event: .adAlreadyLoaded)
            case .adLoaded:listener.onEvent(placementId: 1, event: .adLoaded)
            case .adEmpty:listener.onEvent(placementId: 1, event: .adEmpty)
            case .adFailedToLoad:listener.onEvent(placementId: 1, event: .adFailedToLoad)
            case .adShown:listener.onEvent(placementId: 1, event: .adShown)
            case .adFailedToShow:listener.onEvent(placementId: 1, event: .adFailedToShow)
            case .adClicked:listener.onEvent(placementId: 1, event: .adClicked)
            case .adEnded:listener.onEvent(placementId: 1, event: .adEnded)
            case .adClosed:listener.onEvent(placementId: 1, event: .adClosed)
            }
        }
    }
}
