//
//  PlacementCellView.swift
//  AwesomeAdsSDKKitchenSink
//
//  Created by Myles Eynon on 19/01/2023.
//

import SwiftUI

struct PlacementCellView: View {

    let placement: PlacementItem

    var body: some View {
        HStack {
            Text(placement.title)
        }
    }
}
