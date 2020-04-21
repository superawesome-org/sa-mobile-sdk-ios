//
//  SdkInfo.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 17/04/2020.
//

protocol SdkInfoType {
    var version: String { get }
    var bundle: String { get }
    var name: String { get }
    var lang: String { get }
}

struct SdkInfo: SdkInfoType {
    var version: String
    var bundle: String
    var name: String
    var lang: String
    
    init(mainBundle: Bundle, sdkBundle: Bundle, encoder: EncoderType) {
        self.version = sdkBundle.versionNumber ?? ""
        self.bundle = mainBundle.bundleIdentifier ?? ""
        self.name = encoder.encodeUri(mainBundle.name)
        
        if let shortLang = mainBundle.preferredLocalizations.first,
            let region = Locale.current.regionCode {
            self.lang = "\(shortLang)_\(region)"
        } else {
            self.lang = "none"
        }
    }
}
