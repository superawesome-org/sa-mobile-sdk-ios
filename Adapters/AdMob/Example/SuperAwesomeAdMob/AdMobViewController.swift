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
    private var interstitial: GADInterstitialAd?
    private var rewardedAd: GADRewardedAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Banner Ad
        createAndLoadBannerAd()
        
        // Intestitial Ad
        createAndLoadInterstitial()
        
        // Rewarded Ad
        createAndLoadRewardedAd()
    }
    
    func createAndLoadBannerAd() {
        let extra = SAAdMobCustomEventExtra()
        extra.testEnabled = false
        extra.parentalGateEnabled = false
        extra.trasparentEnabled = true
        
        let extras = GADCustomEventExtras()
        extras.setExtras(extra as? [AnyHashable : Any], forLabel: "iOSBannerCustomEvent")
        
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
    
    func createAndLoadInterstitial()  {
        GADInterstitialAd.load(withAdUnitID: interstitialAdUnitId, request: nil){ interstitial, error in
            if error != nil {
                print("[SuperAwesome | AdMob] interstitial failed to load case")
            } else {
                print("[SuperAwesome | AdMob] interstitial successfully loaded")
                print("[SuperAwesome | AdMob] interstitial adapter class name: \(interstitial?.responseInfo.adNetworkClassName ?? "")")
            }
            self.interstitial = interstitial
        }
    }
    
    func createAndLoadRewardedAd(){
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
        
        GADRewardedAd.load(withAdUnitID: rewardAdUnitId, request: request){ rewardedAd, error in
            if error != nil {
                print("[SuperAwesome | AdMob] RewardedAd failed to load case")
            } else {
                print("[SuperAwesome | AdMob] RewardedAd successfully loaded")
                print("[SuperAwesome | AdMob] RewardedAd adapter class name: \(rewardedAd?.responseInfo.adNetworkClassName ?? "")")
            }
            self.rewardedAd = rewardedAd
        }
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
        if let ad = interstitial {
            ad.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    @IBAction func showVideo(_ sender: Any) {
        
        if let ad = rewardedAd{
            ad.present(fromRootViewController: self){
                
            }
        } else {
            print("[SuperAwesome | AdMob] Video ad wasn't ready")
        }
    }
    
}

extension AdMobViewController: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("[SuperAwesome | AdMob] adView:adViewDidReceiveAd:")
    }
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("[SuperAwesome | AdMob] adView:adViewDidDismissScreen:")
    }
}

extension AdMobViewController: GADFullScreenContentDelegate {
    
}
