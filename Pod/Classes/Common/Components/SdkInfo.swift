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

@objc
public class SdkInfo: NSObject, SdkInfoType {
    private static var overriddenVersion: String?

    let sdkVersion: String
    let pluginName: String
    var bundle: String
    var name: String
    var lang: String

    init(mainBundle: Bundle, sdkBundle: Bundle, locale: Locale, encoder: EncoderType) {
        let platform = "ios"
        let versionNumber = sdkBundle.versionNumber ?? ""

        self.bundle = mainBundle.bundleIdentifier ?? ""
        self.name = encoder.encodeUri(mainBundle.name)

        if let shortLang = mainBundle.preferredLocalizations.first,
           let region = locale.regionCode {
            self.lang = "\(shortLang)_\(region)"
        } else {
            self.lang = "none"
        }

        #if ADMOB_PLUGIN
        self.pluginName = "_admob"
        #else
        self.pluginName = ""
        #endif

        self.sdkVersion = "\(platform)_\(versionNumber)"
    }

    var version: String {
        return "\(SdkInfo.overriddenVersion ?? sdkVersion)\(pluginName)"
    }

    @objc
    public class func overrideVersion(_ version: String?, withPlatform platform: String?) {
        if let platform = platform, let version = version {
            SdkInfo.overriddenVersion = "\(platform)_\(version)"
        } else {
            SdkInfo.overriddenVersion = nil
        }
    }
}
