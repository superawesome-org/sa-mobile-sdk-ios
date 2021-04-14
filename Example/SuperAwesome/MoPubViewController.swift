//
//  MoPubViewController.swift
//  SuperAwesomeExample
//
//  Created by Gunhan Sancar on 19/06/2020.
//

#if MOPUB_PLUGIN

import UIKit
import MoPubSDK
import SuperAwesome

class MoPubViewController: UIViewController {
    private let bannerAdId = "b195f8dd8ded45fe847ad89ed1d016da"
    private let interstitialAdId = "24534e1901884e398f1253216226017e"
    private let videoAdId = "920b6145fb1546cf8b5cf2ac34638bb7"
    
    private var bannerView: MPAdView!
    private var interstitial: MPInterstitialAdController?
    private var interstitialButton: UIButton!
    private var videoButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        
        let configuration = MPMoPubConfiguration.init(adUnitIdForAppInitialization: bannerAdId)
        configuration.loggingLevel = .debug
                
        MoPub.sharedInstance().initializeSdk(with: configuration) {
            print("MoPub SDK initialisation complete")
            
            self.configureBanner()
            self.configureInterstitial()
            self.configureVideo()
        }
    }
    
    private func initUI() {
        // banner view
        bannerView = MPAdView(adUnitId: bannerAdId)
        bannerView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bannerView)
        
        NSLayoutConstraint.activate([
            bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            bannerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // interstitial button
        interstitialButton = UIButton()
        interstitialButton.translatesAutoresizingMaskIntoConstraints = false
        interstitialButton.setTitle("Interstitial", for: .normal)
        interstitialButton.setTitleColor(.black, for: .normal)
        interstitialButton.addTarget(self, action: #selector(didInterstitialClick), for: .touchUpInside)

        view.addSubview(interstitialButton)
        
        NSLayoutConstraint.activate([
            interstitialButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            interstitialButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            interstitialButton.widthAnchor.constraint(equalToConstant: 100),
            interstitialButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // video button
        videoButton = UIButton()
        videoButton.translatesAutoresizingMaskIntoConstraints = false
        videoButton.setTitle("Video", for: .normal)
        videoButton.setTitleColor(.black, for: .normal)
        videoButton.addTarget(self, action: #selector(didVideoClick), for: .touchUpInside)

        view.addSubview(videoButton)
        
        NSLayoutConstraint.activate([
            videoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            videoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            videoButton.widthAnchor.constraint(equalToConstant: 100),
            videoButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func didInterstitialClick(_ sender: UIButton) {
        if interstitial?.ready ?? false {
            interstitial?.show(from: self)
        } else {
            print("interstitial is not ready")
        }
    }
    
    @objc func didVideoClick(_ sender: UIButton) {
        if MPRewardedVideo.hasAdAvailable(forAdUnitID: videoAdId) {
            MPRewardedVideo.presentAd(forAdUnitID: videoAdId, from: self, with: nil)
        } else {
            print("video ad is not ready")
        }
    }
    
    private func configureBanner() {
        bannerView.delegate = self
        bannerView.loadAd(withMaxAdSize: kMPPresetMaxAdSize50Height)
    }
    
    private func configureInterstitial() {
        interstitial = MPInterstitialAdController(forAdUnitId: interstitialAdId)
        interstitial?.loadAd()
    }
    
    private func configureVideo() {
        MPRewardedVideo.loadAd(withAdUnitID: videoAdId, withMediationSettings: nil)
        MPRewardedVideo.setDelegate(self, forAdUnitId: videoAdId)
    }
    
}

extension MoPubViewController: MPAdViewDelegate {
    func viewControllerForPresentingModalView() -> UIViewController! { self }
}

extension MoPubViewController: MPRewardedVideoDelegate {
    func rewardedVideoAdDidFailToLoad(forAdUnitID adUnitID: String!, error: Error!) {
        print("MoPubViewController: rewardedVideoAdDidFailToLoad: error:\(String(describing: error))")
    }
}

#endif
