//
//  Configuration.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 03/11/2020.
//

/// Configuration options for the AwesomeAds SDK
public class Configuration {
    var environment = Environment.production
    var logging = false
    
    public init(environment: Environment = .production, logging: Bool = false) {
        self.environment = environment
        self.logging = logging
    }
}
