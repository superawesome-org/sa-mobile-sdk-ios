//
//  IronSourceDelegates.swift
//  SuperAwesomeIronSourceExample
//
//  Created by Matheus Finatti on 31/07/2023.
//

import UIKit
import IronSource
import SwiftUI

class SharedState : ObservableObject {
    @Published var isRewardedVideoLoaded = false
    @Published var isInterstitialLoaded = false
    @Published var videoRewarded = false
    @Published var haveToLoadInterstitial = false
    @Published var rewardedVideoLoadError: Error? = nil
    @Published var interstitialLoadError: Error? = nil
}

class IronSourceViewController : UIViewController, LevelPlayRewardedVideoDelegate, LevelPlayInterstitialDelegate, ISInitializationDelegate {

    var contentView: UIHostingController<ContentView>? = nil
    var sharedState = SharedState()

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView = UIHostingController(rootView: ContentView(sharedState: self.sharedState, viewController: self))

        setupIronSourceSdk()
        addChild(contentView!)
        view.addSubview(contentView!.view)
        setupConstraints()
    }

    private func setupIronSourceSdk() {
        IronSource.setLevelPlayRewardedVideoDelegate(self)
        IronSource.setLevelPlayInterstitialDelegate(self)
        IronSource.initWithAppKey("1b0b7f8f5",
                                  adUnits: [IS_REWARDED_VIDEO, IS_INTERSTITIAL],
                                  delegate: self)

        ISIntegrationHelper.validateIntegration()
    }

    fileprivate func setupConstraints() {
        contentView!.view.translatesAutoresizingMaskIntoConstraints = false
        contentView!.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView!.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView!.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentView!.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    // MARK: ISInitializationDelegate
    func initializationDidComplete() {
        debugPrint("InitializationDidComplete")
        IronSource.loadInterstitial()
    }

    // MARK: LevelPlayRewardedVideoDelegate
    func hasAvailableAd(with adInfo: ISAdInfo!) {
        print("Has available ad \(adInfo!)")
        sharedState.isRewardedVideoLoaded = true
    }

    func hasNoAvailableAd() {
        print("Has no available ad")
        sharedState.isRewardedVideoLoaded = false
    }

    func didReceiveReward(forPlacement placementInfo: ISPlacementInfo!, with adInfo: ISAdInfo!) {
        debugPrint("Did receive reward for placement \(placementInfo!)")
        sharedState.videoRewarded = true
    }

    func didFailToShowWithError(_ error: Error!, andAdInfo adInfo: ISAdInfo!) {
        debugPrint("Did fail to show ad \(error!)")
        sharedState.rewardedVideoLoadError = error
    }

    func didOpen(with adInfo: ISAdInfo!) {
        debugPrint("Did open ad \(adInfo!)")
    }

    func didClick(_ placementInfo: ISPlacementInfo!, with adInfo: ISAdInfo!) {
        debugPrint("Did click ad \(adInfo!)")
    }

    func didClose(with adInfo: ISAdInfo!) {
        debugPrint("Did close ad \(adInfo!)")
    }

    // MARK: LevelPlayInterstitialDelegate
    func didLoad(with adInfo: ISAdInfo!) {
        debugPrint("Did load interstitial \(adInfo!)")
        sharedState.isInterstitialLoaded = true
    }

    func didFailToLoadWithError(_ error: Error!) {
        debugPrint("Did Fail to load interstitial \(error!)")
        sharedState.isInterstitialLoaded = false
        sharedState.interstitialLoadError = error
    }

    func didShow(with adInfo: ISAdInfo!) {
        debugPrint("Did show interstitial \(adInfo!)")
        sharedState.isInterstitialLoaded = false
        sharedState.haveToLoadInterstitial = true
    }

    func didClick(with adInfo: ISAdInfo!) {
        debugPrint("Did click interstitial \(adInfo!)")
    }
}
