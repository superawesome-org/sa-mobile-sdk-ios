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
        options.debugLoggingEnabled = loggingEnabled
        let analytics = SUPMoatAnalytics.sharedInstance()
        analytics?.start(with: options)

        print("SuperAwesome-Moat-Module Called 'initMoat' and moat is enabled")
    }

    func register(_ container: DependencyContainer) {
        container.factory(MoatRepositoryType.self) { container, param in
            guard let adResponse = param[0] as? AdResponse else {
                fatalError()
            }
            return MoatRepository(adResponse: adResponse,
                           moatLimiting: (param[1] != nil),
                           logger: container.resolve(param: MoatRepository.self),
                           numberGenerator: container.resolve())
        }
    }
}
