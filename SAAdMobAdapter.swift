//
//  SAAdMobAdapter.swift
//  SuperAwesomeAdMob
//
//  Created by Gunhan Sancar on 19/01/2023.
//

import GoogleMobileAds
import SuperAwesome

@objc(SAAdMobAdapter)
class SAAdMobAdapter: NSObject, GADMediationAdapter {
    
    fileprivate var bannerAd: SAAdMobBannerAd? = nil
    
    required override init() {
        super.init()
    }
    
    static func adapterVersion() -> GADVersionNumber {
        let versionNumber = AwesomeAds.info()?.versionNumber ?? ""
        let versionComponents = versionNumber.components(separatedBy: ".")
        var version = GADVersionNumber()
        if versionComponents.count == 3 {
            version.majorVersion = Int(versionComponents[0]) ?? 0
            version.minorVersion = Int(versionComponents[1]) ?? 0
            version.patchVersion = (Int(versionComponents[2]) ?? 0) * 100
        }
        return version
    }
    
    static func adSDKVersion() -> GADVersionNumber {
        let versionNumber = AwesomeAds.info()?.versionNumber ?? ""
        let versionComponents = versionNumber.components(separatedBy: ".")
        
        if versionComponents.count >= 3 {
            let majorVersion = Int(versionComponents[0]) ?? 0
            let minorVersion = Int(versionComponents[1]) ?? 0
            let patchVersion = Int(versionComponents[2]) ?? 0
            
            return GADVersionNumber(majorVersion: majorVersion,
                                    minorVersion: minorVersion,
                                    patchVersion: patchVersion)
        }
        
        return GADVersionNumber()
    }
    
    static func networkExtrasClass() -> GADAdNetworkExtras.Type? {
        return nil
    }
    
    func loadBanner(for adConfiguration: GADMediationBannerAdConfiguration, completionHandler: @escaping GADMediationBannerLoadCompletionHandler) {
        bannerAd = SAAdMobBannerAd()
        bannerAd?.loadBanner(for: adConfiguration, completionHandler: completionHandler)
    }
    
    func loadInterstitial(for adConfiguration: GADMediationInterstitialAdConfiguration, completionHandler: @escaping GADMediationInterstitialLoadCompletionHandler) {
        
    }
    
    func loadRewardedAd(for adConfiguration: GADMediationRewardedAdConfiguration, completionHandler: @escaping GADMediationRewardedLoadCompletionHandler) {
        
    }
}
