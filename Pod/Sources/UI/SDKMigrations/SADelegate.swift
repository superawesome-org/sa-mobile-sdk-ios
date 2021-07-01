//
//  SADelegate.swift
//  mopub-ios-sdk
//
//  Created by Mark on 15/06/2021.
//

import Foundation

@available(*, deprecated, renamed: "AdEventCallback" )
public protocol SADelegate {
    func onEvent(placementId: Int, event: SAEvent)
}

@available(*, deprecated, renamed: "AdEvent" )
public enum SAEvent {
    case adLoaded
    case adEmpty
    case adFailedToLoad
    case adAlreadyLoaded
    case adShown
    case adFailedToShow
    case adClicked
    case adEnded
    case adClosed
}
