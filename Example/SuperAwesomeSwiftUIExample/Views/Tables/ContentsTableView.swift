//
//  ContentsTableView.swift
//  AwesomeAdsSDKKitchenSink
//
//  Created by Myles Eynon on 18/01/2023.
//

import SuperAwesome
import SwiftUI

public struct ContentsTableView: View {

    var features: [FeatureItem]?

    public var body: some View {
        List(features ?? [], id: \.id) { feature in
            NavigationLink(
                destination: {
                    FeatureDetailView(feature: feature)
                },
                label: {
                    Text(feature.type.title)
                }
            )
        }
    }
}

struct ContentsTableView_Previews: PreviewProvider {
    static var previews: some View {
        ContentsTableView(
            features: [
                FeatureItem(
                    type: .banner,
                    placements: [
                        PlacementItem(name: "Banner",
                                      type: .banner,
                                      placementId: 0,
                                      lineItemId: nil,
                                      creativeId: nil)
                    ]
                ),
                FeatureItem(
                    type: .interstial,
                    placements: [
                        PlacementItem(name: "Interstitial",
                                      type: .interstial,
                                      placementId: 0,
                                      lineItemId: nil,
                                      creativeId: nil)
                    ]
                )
            ]
        )
    }
}
