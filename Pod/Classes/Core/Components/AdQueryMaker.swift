//
//  AdQueryMaker.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 17/04/2020.
//

protocol AdQueryMakerType {
    func make(_ request: AdRequest) -> AdQuery
}

class AdQueryMaker: AdQueryMakerType {
    private let device: DeviceType
    private let sdkInfo: SdkInfoType
    
    init(device: DeviceType, sdkInfo: SdkInfoType) {
        self.device = device
        self.sdkInfo = sdkInfo
    }
    
    func make(_ request: AdRequest) -> AdQuery {
        return AdQuery(test: request.test,
                       sdkVersion: sdkInfo.version,
                       rnd: 1,
                       bundle: sdkInfo.bundle,
                       name: sdkInfo.name,
                       dauid: 1,
                       ct: .wifi,
                       lang: sdkInfo.lang,
                       device: device.genericType,
                       pos: request.pos,
                       skip: request.skip,
                       playbackmethod: request.playbackmethod,
                       startdelay: request.startdelay,
                       instl: request.instl,
                       w: request.w,
                       h: request.h)
    }
}
