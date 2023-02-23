//
//  FeatureDetailView.swift
//  AwesomeAdsSDKKitchenSink
//
//  Created by Myles Eynon on 18/01/2023.
//

import SuperAwesome
import SwiftUI

struct FeatureDetailView: View {

    private let adHeight = 50.0
    private let padding = 16.0

    @State var feature: FeatureItem
    @State private var selectedPlacement: PlacementItem?
    @State private var isTestModeEnabled: Bool = false
    @State private var isBumperEnabled: Bool = false
    @State private var isParentGateEnabled: Bool = false
    @State private var isVideoMutedOnStart: Bool = false
    @State private var isCloseButtonEnabled: Bool = false

    var body: some View {
        VStack {
            PlacementsTableView(placements: feature.placements,
                                selectedPlacement: $selectedPlacement.onChange(perform: { newValue, _ in
                if let selectedPlacement = newValue {
                    loadAd(featureType: feature.type, placement: selectedPlacement)
                }
            }))
            .padding(.bottom, padding)

            if feature.type == .banner {
                AdBannerView(
                    placement: $selectedPlacement,
                    isTestModeEnabled: $isTestModeEnabled,
                    isBumperEnabled: $isBumperEnabled,
                    isParentGateEnabled: $isParentGateEnabled
                )
                .frame(height: adHeight)
                .frame(maxWidth: .infinity)
                .padding(.bottom, padding)
            }

            VStack {
                Toggle("Test Mode", isOn: $isTestModeEnabled.onChange(perform: { newValue, _ in
                    toggleTestMode(isTestModeEnabled: newValue)
                }))
                Toggle("Bumper", isOn: $isBumperEnabled.onChange(perform: { newValue, _ in
                    toggleBumper(isBumperEnabled: newValue)
                }))
                Toggle("Parent Gate", isOn: $isParentGateEnabled.onChange(perform: { newValue, _ in
                    toggleParentGate(isParentGateEnabled: newValue)
                }))
                if feature.type == .interstial || feature.type == .video {
                    Toggle("Close Button\(feature.type == .interstial ? " with delay" : "")",
                           isOn: $isCloseButtonEnabled.onChange(perform: { newValue, _ in
                        toggleCloseButton(isCloseButtonEnabled: newValue)
                    }))
                }
                if feature.type == .video {
                    Toggle("Mute video on start", isOn: $isVideoMutedOnStart.onChange(perform: { newValue, _ in
                        toggleVideoMutedOnStart(isVideoMutedOnStart: newValue)
                    }))
                }
            }
            .padding(.leading, padding)
            .padding(.trailing, padding)

            Spacer()
        }.navigationTitle(feature.type.title)
    }

    private func loadAd(featureType: FeatureType, placement: PlacementItem) {
        guard featureType != .banner else { return }
        if let lineItemId = placement.lineItemId, let creativeId = placement.creativeId {
            if featureType == .interstial {
                InterstitialAd.load(placement.placementId,
                                    lineItemId: lineItemId,
                                    creativeId: creativeId)
            } else if featureType == .video {
                VideoAd.load(withPlacementId: placement.placementId,
                             lineItemId: lineItemId,
                             creativeId: creativeId)
            }
        } else {
            if featureType == .interstial {
                InterstitialAd.load(placement.placementId)
            } else if featureType == .video {
                VideoAd.load(withPlacementId: placement.placementId)
            }
        }
    }

    private func toggleTestMode(isTestModeEnabled: Bool) {
        switch feature.type {
        case .interstial:
            isTestModeEnabled ? InterstitialAd.enableTestMode() : InterstitialAd.enableTestMode()
        case .video:
            isTestModeEnabled ? VideoAd.enableTestMode() : VideoAd.enableTestMode()
        default:
            return
        }
    }

    private func toggleBumper(isBumperEnabled: Bool) {
        switch feature.type {
        case .interstial:
            isBumperEnabled ? InterstitialAd.enableBumperPage() : InterstitialAd.disableBumperPage()
        case .video:
            isBumperEnabled ? VideoAd.enableBumperPage() : VideoAd.disableBumperPage()
        default:
            return
        }
    }

    private func toggleParentGate(isParentGateEnabled: Bool) {
        switch feature.type {
        case .interstial:
            isParentGateEnabled ? InterstitialAd.enableParentalGate() : InterstitialAd.disableParentalGate()
        case .video:
            isParentGateEnabled ? VideoAd.enableParentalGate() : VideoAd.disableParentalGate()
        default:
            return
        }
    }

    private func toggleCloseButton(isCloseButtonEnabled: Bool) {
        switch feature.type {
        case .interstial:
            isCloseButtonEnabled ? InterstitialAd.enableCloseButton() : InterstitialAd.enableCloseButtonNoDelay()
        case .video:
            isCloseButtonEnabled ? VideoAd.enableCloseButton() : VideoAd.disableCloseButton()
        default:
            return
        }
    }

    private func toggleVideoMutedOnStart(isVideoMutedOnStart: Bool) {
        switch feature.type {
        case .video:
            isVideoMutedOnStart ? VideoAd.enableMuteOnStart() : VideoAd.disableMuteOnStart()
        default:
            return
        }
    }
}
