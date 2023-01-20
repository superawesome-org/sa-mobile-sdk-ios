//
//  SAAdMobBannerAd.swift
//  SuperAwesomeAdMob
//
//  Created by Gunhan Sancar on 19/01/2023.
//

import GoogleMobileAds
import SuperAwesome

@objc(SAAdMobBannerAd)
class SAAdMobBannerAd: NSObject, GADMediationBannerAd {

    var view: UIView {
       bannerAd ?? UIView()
    }
    
    required override init() {
        super.init()
    }
    
    /// AwesomeAds banner ad.
    var bannerAd: BannerView?
    
    /// The ad event delegate to forward ad rendering events to the Google Mobile Ads SDK.
    var delegate: GADMediationBannerAdEventDelegate?
    
    /// Completion handler called after ad load
    var completionHandler: GADMediationBannerLoadCompletionHandler?
    
    func loadBanner(
        for adConfiguration: GADMediationBannerAdConfiguration,
        completionHandler: @escaping GADMediationBannerLoadCompletionHandler
    ) {
        let parameter = adConfiguration.credentials.settings["parameter"] as? String ?? ""
        let placementId = Int(parameter) ?? 0
        let adSize = adConfiguration.adSize
        
        bannerAd = BannerView(frame: CGRect(x: 0, y: 0, width: adSize.size.width, height: adSize.size.height))
        bannerAd?.setCallback({ [weak self] placementId, event in
            self?.onEvent(placementId, event)
        })
        self.completionHandler = completionHandler
        bannerAd?.load(placementId)
    }
    
    private func onEvent(_ placementId: Int, _ event: AdEvent) {
        switch event {
        case .adLoaded: adLoaded()
        case .adEmpty: adError(message: "Ad is empty")
        case .adFailedToLoad: adError(message: "Ad failed to laod")
        case .adClicked: adClicked()
        default:
            break
        }
    }
    
    private func adLoaded() {
        if let handler = completionHandler {
            delegate = handler(self, nil)
        }
        bannerAd?.play()
    }
    
    private func adError(message: String) {
        let error = NSError(domain: "tv.superawesome.SAAdMobBannerAd",
                            code: 0,
                            userInfo: [ NSLocalizedDescriptionKey: message])
        
        if let handler = completionHandler {
            delegate = handler(nil, error)
        }
    }
    
    private func adClicked() {
        delegate?.reportClick()
        delegate?.willPresentFullScreenView()
    }
}
