//
//  ContentView.swift
//  AwesomeAdsSDKKitchenSink
//
//  Created by Myles Eynon on 17/01/2023.
//

import Combine
import SuperAwesome
import SwiftUI

struct RootView: View {

    @StateObject
    private var viewModel = FeaturesViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Text("AwesomeAds version: \(AwesomeAds.info()?.versionNumber ?? "")")
                ContentsTableView(features: viewModel.features.features)
            }.navigationTitle("Features")
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
