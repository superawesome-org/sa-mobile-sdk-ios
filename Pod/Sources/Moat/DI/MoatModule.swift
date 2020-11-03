//
//  InterstitialAd.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 04/09/2020.
//

import SUPMoatMobileAppKit

class MoatModule: DependencyModule {
    func initMoat(_ loggingEnabled: Bool) {
        let options = SUPMoatOptions()
        options.idfaCollectionEnabled = false
        options.debugLoggingEnabled = loggingEnabled
        let analytics = SUPMoatAnalytics.sharedInstance()
        analytics?.start(with: options)
        
        print("SuperAwesome-Moat-Module Called 'initMoat' and moat is enabled")
    }
    
    func register(_ container: DependencyContainer) {
        container.factory(MoatRepositoryType.self) { c, param in
            MoatRepository(adResponse: param[0] as! AdResponse,
                           moatLimiting: (param[1] != nil),
                           logger: c.resolve(param: MoatRepository.self),
                           numberGenerator: c.resolve())
        }
    }
}
