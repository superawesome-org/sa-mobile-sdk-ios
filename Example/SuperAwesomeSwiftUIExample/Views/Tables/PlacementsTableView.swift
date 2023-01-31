//
//  PlacementsTableView.swift
//  AwesomeAdsSDKKitchenSink
//
//  Created by Myles Eynon on 19/01/2023.
//

import SwiftUI

struct PlacementsTableView: View {

    @State var placements: [PlacementItem] = []
    @Binding var selectedPlacement: PlacementItem?

    var body: some View {
        List(placements, id: \.id) { placement in
            Button(placement.title) {
                selectedPlacement = placement
            }.frame(maxWidth: .infinity)
                .listRowSeparator(.hidden)
        }
    }
}
