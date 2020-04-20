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
    private let connectionManager: ConnectionManagerType
    private let numberGenerator: NumberGeneratorType
    private let idGenerator: IdGeneratorType
    
    init(device: DeviceType,
         sdkInfo: SdkInfoType,
         connectionManager: ConnectionManagerType,
         numberGenerator: NumberGeneratorType,
         idGenerator: IdGeneratorType) {
        self.device = device
        self.sdkInfo = sdkInfo
        self.connectionManager = connectionManager
        self.numberGenerator = numberGenerator
        self.idGenerator = idGenerator
    }
    
    func make(_ request: AdRequest) -> AdQuery {
        return AdQuery(test: request.test,
                       sdkVersion: sdkInfo.version,
                       rnd: numberGenerator.nextIntForCache(),
                       bundle: sdkInfo.bundle,
                       name: sdkInfo.name,
                       dauid: idGenerator.findDauId(),
                       ct: connectionManager.findConnectionType(),
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
