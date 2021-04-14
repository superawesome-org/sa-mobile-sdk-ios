//
//  AwesomeAdsMoPubAdapterConfiguration.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 19/06/2020.
//

import Foundation
import MoPubSDK

@objc
public class AwesomeAdsMoPubAdapterConfiguration: MPBaseAdapterConfiguration {
    public override var adapterVersion: String { "\(SAVersion.getSdkVersion() ?? "0.0.0").0" }
    public override var moPubNetworkName: String { "awesomeads" }
    public override var networkSdkVersion: String { SAVersion.getSdkVersion() }
    public override var biddingToken: String? { nil }
    public override func initializeNetwork(withConfiguration configuration: [String : Any]?, complete: ((Error?) -> Void)? = nil) {
        AwesomeAds.initSDK(false)
        complete?(nil)
    }
}
