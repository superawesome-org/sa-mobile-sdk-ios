//
//  SuperAwesomeSwiftUIExampleApp.swift
//  SuperAwesomeSwiftUIExample
//
//  Created by Myles Eynon on 25/01/2023.
//

import SuperAwesome
import SwiftUI

@main
struct SuperAwesomeSwiftUIExampleApp: App {

    init() {
        AwesomeAds.initSDK(configuration: Configuration(environment: .production, logging: true)) {
            print("AwesomeAds SDK init complete")
        }
        BumperPage.overrideName("AA SDK Swift UI Example App")
        configureInterstitial()
        configureVideo()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }

    // MARK: SuperAwesome AD SDK Config

    private func configureInterstitial() {
        InterstitialAd.setCallback { placementId, event in
            print("InterstitialAd Callback >> \(event.name())")

            if event == .adLoaded, let rootVC = UIApplication.shared.rootViewController {
                InterstitialAd.play(placementId, fromVC: rootVC)
            }
        }
    }

    private func configureVideo() {
        VideoAd.enableCloseButton()
        VideoAd.setCallback { placementId, event in
            print("VideoAd Callback >> \(event.name())")

            if event == .adLoaded, let rootVC = UIApplication.shared.rootViewController {
                VideoAd.play(withPlacementId: placementId, fromVc: rootVC)
            }
        }
    }
}
