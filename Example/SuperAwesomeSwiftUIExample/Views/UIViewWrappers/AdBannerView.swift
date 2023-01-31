//
//  AdBannerView.swift
//  AwesomeAdsSDKKitchenSink
//
//  Created by Myles Eynon on 18/01/2023.
//

import SuperAwesome
import SwiftUI
import UIKit

struct AdBannerView: UIViewRepresentable {

    @Binding var placement: PlacementItem?
    @Binding var isTestModeEnabled: Bool
    @Binding var isBumperEnabled: Bool
    @Binding var isParentGateEnabled: Bool

    func makeUIView(context: Context) -> BannerView {
        let view = BannerView()
        view.setCallback { _, event in
            print("BannerView Callback >> \(event.name())")

            if event == .adLoaded {
                view.play()
            }
        }

        return view
    }

    func updateUIView(_ uiView: BannerView, context: Context) {

        isTestModeEnabled ? uiView.enableTestMode() : uiView.disableTestMode()
        isBumperEnabled ? uiView.enableBumperPage() : uiView.disableBumperPage()
        isParentGateEnabled ? uiView.enableParentalGate() : uiView.disableParentalGate()

        guard let placement = placement else { return }

        if let creativeId = placement.creativeId,
           let lineItemId = placement.lineItemId {
            uiView.load(placement.placementId, lineItemId: lineItemId, creativeId: creativeId)
        } else {
            uiView.load(placement.placementId)
        }
    }
}
