//
//  AwesomeAdsMoPubAdHelper.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 22/06/2020.
//

import Foundation

class AwesomeAdsMoPubAdHelper {
    func isEmpty(_ ad: SAAd?) -> Bool {
        return ad?.creative.details.media.html?.contains("mopub://failLoad") ?? true
    }
}
