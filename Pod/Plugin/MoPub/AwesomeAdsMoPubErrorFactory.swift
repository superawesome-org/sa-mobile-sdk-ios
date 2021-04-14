//
//  AwesomeAdsMoPubErrorFactory.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 22/06/2020.
//

import Foundation
import MoPubSDK

class AwesomeAdsMoPubErrorFactory {
    func makeError(message:String, placementId: Int, errorCode: MOPUBErrorCode) -> Error {
        let error = NSError(domain:"", code:Int(errorCode.rawValue), userInfo:[ NSLocalizedDescriptionKey: "Error:\(message) PlacementId: \(placementId)"]) as Error
        return error
    }
}
