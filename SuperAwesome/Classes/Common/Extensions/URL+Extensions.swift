//
//  URL+Extensions.swift
//  SuperAwesome
//
//  Created by Myles Eynon on 09/05/2023.
//

import Foundation

public extension URL {
    
    var cleanBaseUrl: String? {
        guard let uScheme = self.scheme, let uHost = self.host else { return nil }
        return uScheme + "://" + uHost
    }
}
