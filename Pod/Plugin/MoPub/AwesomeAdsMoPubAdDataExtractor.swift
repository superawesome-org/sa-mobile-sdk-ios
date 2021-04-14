//
//  AwesomeAdsAdDataExtractor.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 19/06/2020.
//

import Foundation
import MoPubSDK

class AwesomeAdsMoPubAdDataExtractor {
    private let info: [AnyHashable : Any]
    
    init(_ info: [AnyHashable : Any]) {
        self.info = info
    }
    
    var placementId: Int {
        return info["placementId"] as? Int ?? Int(SA_DEFAULT_PLACEMENTID)
    }
    
    var isTestEnabled: Bool {
        return info["isTestEnabled"] as? Bool ??  Bool(truncating: SA_DEFAULT_TESTMODE as NSNumber) 
    }
    
    var isParentalGateEnabled: Bool {
        return info["isParentalGateEnabled"] as? Bool ??  Bool(truncating: SA_DEFAULT_PARENTALGATE as NSNumber)
    }
    
    var isBumperPageEnabled: Bool {
        return info["isBumperPageEnabled"] as? Bool ??  Bool(truncating: SA_DEFAULT_BUMPERPAGE as NSNumber)
    }
    
    var shouldShowCloseButton: Bool {
        return info["shouldShowCloseButton"] as? Bool ??  Bool(truncating: SA_DEFAULT_BACKBUTTON as NSNumber)
    }
    
    var shouldShowSmallClickButton: Bool {
        return info["shouldShowSmallClickButton"] as? Bool ??  Bool(truncating: SA_DEFAULT_SMALLCLICK as NSNumber)
    }
    
    var shouldAutomaticallyCloseAtEnd: Bool {
        return info["shouldAutomaticallyCloseAtEnd"] as? Bool ??  Bool(truncating: SA_DEFAULT_CLOSEATEND as NSNumber)
    }
    
    var playbackMode: SARTBStartDelay {
        let playbackMode = info["playbackMode"] as? String

        switch playbackMode {
        case "POST_ROLL": return SARTBStartDelay.DL_POST_ROLL
        case "MID_ROLL": return SARTBStartDelay.DL_MID_ROLL
        case "PRE_ROLL": return SARTBStartDelay.DL_PRE_ROLL
        case "GENERIC_MID_ROLL": return SARTBStartDelay.DL_GENERIC_MID_ROLL
        default: return SARTBStartDelay.DL_PRE_ROLL
        }
    }
    
    var configuration: SAConfiguration {
        return info["configuration"] as? String == "STAGING" ?
            SAConfiguration.STAGING : SAConfiguration.PRODUCTION
    }
    
    var orientation: SAOrientation {
        var result = SAOrientation.ANY
        let value = info["orientation"] as? String
        
        if value == "PORTRAIT" {
            result = SAOrientation.PORTRAIT
        } else if value == "LANDSCAPE" {
            result = SAOrientation.LANDSCAPE
        }
        
        return result
    }
}
