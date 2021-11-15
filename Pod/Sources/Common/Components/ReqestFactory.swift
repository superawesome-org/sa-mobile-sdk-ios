//
//  ReqestFactory.swift
//  SuperAwesome
//
//  Created by Mark on 10/06/2021.
//

import UIKit

class RequestFactoryImpl {
    func makeRequest(isTestEnabled: Bool = false, screen: ForView, size: CGSize, delay: AdRequest.StartDelay  = .preRoll) -> AdRequest {
        return AdRequest(test: isTestEnabled,
                          position: screen.position,
                          skip: screen.skip,
                          instl: screen.fullScreen,
                          width: Int(size.width),
                          height: Int(size.height),
                          startDelay: delay)
    }

    enum ForView {
        case bannerView
        case interstitial
        case video

        var position: AdRequest.Position {
            if self == .bannerView {
                return .aboveTheFold
            }
            return .fullScreen
        }

        var skip: AdRequest.Skip {
            if self == .bannerView {
                return .no
            }
            return .yes
        }

        var fullScreen: AdRequest.FullScreen {
            if self == .bannerView {
                return .off
            }
            return .on
        }

        var delay: AdRequest.StartDelay {
            switch self {
            default:
                return .preRoll
            }
        }
    }
}
