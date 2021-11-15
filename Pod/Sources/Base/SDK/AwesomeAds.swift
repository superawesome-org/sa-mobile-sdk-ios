//
//  AwesomeAdsSdk.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 26/04/2020.
//

import Foundation

@objc
public class AwesomeAds: NSObject {
    public static let shared = AwesomeAds()

    private(set) var container: DependencyContainer = DependencyContainer()
    private var initialised: Bool = false

    private func registerMoatModule(_ loggingEnabled: Bool) {
        #if MOAT_MODULE
        let module = MoatModule()
        module.initMoat(loggingEnabled)
        module.register(container)
        #else
        debugPrint("Moat module is not available. Skipping.")
        #endif
    }

    private func registerDependencies(_ configuration: Configuration) {
        self.container = DependencyContainer()

        CommonModule(configuration: configuration).register(container)
        registerMoatModule(configuration.logging)
        NetworkModule().register(container)
        UIModule().register(container)

        InjectableComponent.register(self.container)
    }

    /// Initialise the AwesomeAds SDK.
    ///
    /// - Parameter logging: enables or disables the logging of the SDK
    public static func initSDK(_ logging: Bool) {
        shared.initSDK(configuration: Configuration(environment: .production, logging: logging), completion: nil)
    }

    /// Initialise the AwesomeAds SDK.
    ///
    /// - Parameter configuration: to set various options including environment, and logging
    /// - Parameter complition: Callback closure to be notified once the initialisation is done
    public static func initSDK(configuration: Configuration = Configuration(),
                               completion: (() -> Void)? = nil) {
        shared.initSDK(configuration: configuration, completion: completion)
    }

    /// Initialise the AwesomeAds SDK.
    ///
    /// - Parameter configuration: to set various options including environment, and logging
    /// - Parameter complition: Callback closure to be notified once the initialisation is done
    public func initSDK(configuration: Configuration = Configuration(),
                        completion: (() -> Void)? = nil) {
        guard !initialised else { return }
        registerDependencies(configuration)
        initialised = true
        completion?()
    }
}
