//
//  ContentView.swift
//  AwesomeAdsSDKKitchenSink
//
//  Created by Myles Eynon on 17/01/2023.
//

import SuperAwesome
import SwiftUI

struct RootView: View {

    let features: [FeatureItem] = [
        FeatureItem(
            type: .banner,
            placements: [
                PlacementItem(type: .banner, placementId: 82088),
                PlacementItem(name: "Solid Colour", type: .banner, placementId: 88001),
                PlacementItem(name: "Test Multi ID",
                              type: .banner,
                              placementId: 82088,
                              lineItemId: 176803,
                              creativeId: 499387)
            ]
        ),
        FeatureItem(
            type: .interstial,
            placements: [
                PlacementItem(name: "Flat Colour Portrait", type: .interstial, placementId: 87892),
                PlacementItem(name: "Portrait", type: .interstial, placementId: 82089),
                PlacementItem(name: "via KSF", type: .interstial, placementId: 82088),
                PlacementItem(name: "Flat Colour via KSF", type: .interstial, placementId: 87970),
                PlacementItem(name: "Test Multi ID",
                              type: .interstial,
                              placementId: 82089,
                              lineItemId: 176803,
                              creativeId: 503038)
            ]
        ),
        FeatureItem(
            type: .video,
            placements: [
                PlacementItem(name: "PopJam VPAID", type: .video, placementId: 93969),
                PlacementItem(name: "PopJam Celtra VPAID Ad", type: .video, placementId: 90636),
                PlacementItem(name: "VAST Flat Colour", type: .video, placementId: 88406),
                PlacementItem(name: "VPAID Flat Colour", type: .video, placementId: 89056),
                PlacementItem(name: "Direct Flat Colour", type: .video, placementId: 87969),
                PlacementItem(name: "Direct", type: .video, placementId: 82090),
                PlacementItem(name: "VAST", type: .video,
                              placementId: 84777,
                              lineItemId: 178822,
                              creativeId: 503585),
                PlacementItem(name: "VPAID via KSF", type: .video, placementId: 84798),
                PlacementItem(name: "Test Multi ID",
                              type: .video,
                              placementId: 82090,
                              lineItemId: 176803,
                              creativeId: 499385)
            ]
        )
    ]

    var body: some View {
        NavigationView {
            // TODO: Populate with Firebase DB? Best not to as this is public facing...
            VStack {
                Text("AwesomeAds version: \(AwesomeAds.info()?.versionNumber ?? "")")
                ContentsTableView(features: features)
            }.navigationTitle("Features")
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
