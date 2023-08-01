//
//  ContentView.swift
//  SuperAwesomeIronSourceExample
//
//  Created by Matheus Finatti on 31/07/2023.
//

import SwiftUI
import IronSource

struct ContentView : View {

    @StateObject var sharedState: SharedState

    weak var viewController: UIViewController? = nil

    var body: some View {
        ZStack {
            VStack {
                Image("SALogo")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .imageScale(.medium)
                    .foregroundColor(.accentColor)

                Image("ISLogo")
                    .resizable()
                    .frame(width: 200, height: 50)
                    .imageScale(.small)
                    .foregroundColor(.accentColor)

                Spacer().frame(height: 20)

                Button(interstitialButtonText) {
                    if sharedState.haveToLoadInterstitial {
                        IronSource.loadInterstitial()
                        sharedState.haveToLoadInterstitial = false
                    } else {
                        if let vc = viewController {
                            IronSource.showInterstitial(with: vc)
                        }
                    }

                }
                .buttonStyle(.borderedProminent)
                .disabled(!sharedState.isInterstitialLoaded && !sharedState.haveToLoadInterstitial)

                Button(rewardedVideoText) {
                    if let vc = viewController {
                        IronSource.showRewardedVideo(with: vc)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(!sharedState.isRewardedVideoLoaded)
                .alert("Reward granted", isPresented: $sharedState.videoRewarded) {
                    Button("OK", role: .cancel) {
                        sharedState.videoRewarded = false
                    }
                }

                Text("IronSource SDK \(IronSource.sdkVersion())")

                if let interstitialError =  sharedState.interstitialLoadError {
                    Text("Error loading interstitial: \(interstitialError.localizedDescription)")
                        .foregroundColor(Color.red)
                }
                if let videoError = sharedState.rewardedVideoLoadError {
                    Text("Error loading video: \(videoError.localizedDescription)")
                        .foregroundColor(Color.red)
                }
            }
            .padding()
        }
    }

    var interstitialButtonText: String {
        if sharedState.haveToLoadInterstitial {
            return "Load interstitial"
        }

        if sharedState.isInterstitialLoaded {
            return "Show interstitial"
        } else {
            return "Loading interstitial"
        }
    }

    var rewardedVideoText: String {
        return sharedState.isRewardedVideoLoaded ? "Show rewarded video" : "Loading rewarded video"
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(sharedState: SharedState())
    }
}
