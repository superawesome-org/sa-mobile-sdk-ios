//
//  ViewController.swift
//  SuperAwesomeAdMob
//
//  Created by Gunhan Sancar on 06/02/2020.
//  Copyright (c) 2020 Gunhan Sancar. All rights reserved.
//

import UIKit
import SuperAwesome
import SuperAwesomeAdMob
import GoogleMobileAds

class AdMobViewController: UIViewController {
    private var bannerAdUnitId = "ca-app-pub-2222631699890286/4083046906"
    private var interstitialAdUnitId = "ca-app-pub-2222631699890286/6406350858"
    private var rewardAdUnitId = "ca-app-pub-2222631699890286/3695609060"

    private var bannerView: GADBannerView!
    private var interstitial: GADInterstitial!
    private var rewardedAd: GADRewardedAd!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Banner Ad
        createAndLoadBannerAd()

        // Interstitial Ad
        interstitial = createAndLoadInterstitial()

        // Rewarded Ad
        rewardedAd = createAndLoadRewardedAd()
    }

    func createAndLoadBannerAd() {
        let extra = SAAdMobCustomEventExtra()
        extra.testEnabled = false
        extra.parentalGateEnabled = false
        extra.trasparentEnabled = true
        //extra.configuration = STAGING;

        let extras = GADCustomEventExtras()
        extras.setExtras(extra as? [AnyHashable: Any], forLabel: "iOSBannerCustomEvent")

        let request = GADRequest()
        request.register(extras)

        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints([
            NSLayoutConstraint(item: bannerView, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bannerView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        ])
        bannerView.adUnitID = bannerAdUnitId
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(request)
    }

    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: interstitialAdUnitId)
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }

    func createAndLoadRewardedAd() -> GADRewardedAd {
        let extra = SAAdMobVideoExtra()
        extra.testEnabled = false
        extra.closeAtEndEnabled = true
        extra.closeButtonEnabled = true
        extra.parentalGateEnabled = true
        extra.smallCLickEnabled = true
        //extra.configuration = STAGING;
        //extra.orientation = LANDSCAPE;

        let request = GADRequest()
        request.register(extra)

        let rewardedAd = GADRewardedAd(adUnitID: rewardAdUnitId)
        rewardedAd.load(request, completionHandler: { error in
            if error != nil {
                print("[SuperAwesome | AdMob] RewardedAd failed to load case")
            } else {
                print("[SuperAwesome | AdMob] RewardedAd successfully loaded")
                print("[SuperAwesome | AdMob] RewardedAd adapter class name: \(rewardedAd.responseInfo?.adNetworkClassName ?? "")")
            }
        })
        return rewardedAd
    }

    func addBannerView(bannerView: UIView?) {
        guard let bannerView = bannerView else { return }
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints([
            NSLayoutConstraint(item: bannerView,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: topLayoutGuide,
                               attribute: .bottom,
                               multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: bannerView,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: view,
                               attribute: .centerX,
                               multiplier: 1,
                               constant: 0)
        ])
    }

    @IBAction func showInterstitial(_ sender: Any) {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("[SuperAwesome | AdMob] Interstitial Ad wasn't ready")
        }
    }

    @IBAction func showVideo(_ sender: Any) {
        if rewardedAd.isReady {
            rewardedAd.present(fromRootViewController: self, delegate: self)
        } else {
            print("[SuperAwesome | AdMob] Video ad wasn't ready")
        }
    }

}

extension AdMobViewController: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("[SuperAwesome | AdMob] adView:adViewDidReceiveAd:")
    }
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("[SuperAwesome | AdMob] adView:adViewDidDismissScreen:")
    }
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("[SuperAwesome | AdMob] adView:didFailToReceiveAdWithError:")
    }
}

extension AdMobViewController: GADInterstitialDelegate {
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("[SuperAwesome | AdMob] interstitialDidReceiveAd:")
    }
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("[SuperAwesome | AdMob] interstitialDidReceiveAd:")
    }
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("[SuperAwesome | AdMob] interstitialDidDismissScreen:")
        self.interstitial = createAndLoadInterstitial()
    }
}

extension AdMobViewController: GADRewardedAdDelegate {
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        print("[SuperAwesome | AdMob] rewardedAd:userDidEarnReward: Type:\(reward.type) Amount:\(reward.amount)")
    }
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        print("[SuperAwesome | AdMob] rewardedAdDidDismiss:")
        self.rewardedAd = createAndLoadRewardedAd()
    }
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
        print("[SuperAwesome | AdMob] rewardedAdDidPresent:")
    }
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        print("[SuperAwesome | AdMob] rewardedAd:didFailToPresentWithError")
    }
}
