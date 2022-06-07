//
//  Configuration.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 03/11/2020.
//

/// Configuration options for the AwesomeAds SDK
@objc
public class Configuration: NSObject {
    let environment: Environment
    let logging: Bool
    let options: [String: String]?

    public init(environment: Environment = .production,
                logging: Bool = false,
                options: [String: String]? = nil) {
        self.environment = environment
        self.logging = logging
        self.options = options
    }
}
