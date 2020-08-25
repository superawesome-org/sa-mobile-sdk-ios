//
//  AdQueryMaker.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 17/04/2020.
//

protocol AdQueryMakerType {
    func makeAdQuery(_ request: AdRequest) -> AdQuery
    func makeImpressionQuery(_ request: EventRequest) -> EventQuery
    func makeClickQuery(_ request: EventRequest) -> EventQuery
    func makeVideoClickQuery(_ request: EventRequest) -> EventQuery
    func makeEventQuery(_ request: EventRequest) -> EventQuery
}

class AdQueryMaker: AdQueryMakerType {
    private let device: DeviceType
    private let sdkInfo: SdkInfoType
    private let connectionProvider: ConnectionProviderType
    private let numberGenerator: NumberGeneratorType
    private let idGenerator: IdGeneratorType
    private let encoder: EncoderType
    
    init(device: DeviceType,
         sdkInfo: SdkInfoType,
         connectionProvider: ConnectionProviderType,
         numberGenerator: NumberGeneratorType,
         idGenerator: IdGeneratorType,
         encoder: EncoderType) {
        self.device = device
        self.sdkInfo = sdkInfo
        self.connectionProvider = connectionProvider
        self.numberGenerator = numberGenerator
        self.idGenerator = idGenerator
        self.encoder = encoder
    }
    
    func makeAdQuery(_ request: AdRequest) -> AdQuery {
        return AdQuery(test: request.test,
                       sdkVersion: sdkInfo.version,
                       rnd: numberGenerator.nextIntForCache(),
                       bundle: sdkInfo.bundle,
                       name: sdkInfo.name,
                       dauid: idGenerator.uniqueDauId,
                       ct: connectionProvider.findConnectionType(),
                       lang: sdkInfo.lang,
                       device: device.genericType,
                       pos: request.pos.rawValue,
                       skip: request.skip.rawValue,
                       playbackmethod: request.playbackmethod,
                       startdelay: request.startdelay.rawValue,
                       instl: request.instl.rawValue,
                       w: request.w,
                       h: request.h)
    }
    
    func makeImpressionQuery(_ request: EventRequest) -> EventQuery {
        return EventQuery(placement: request.placementId,
                          bundle: sdkInfo.bundle,
                          creative: request.creativeId,
                          line_item: request.lineItemId,
                          ct: connectionProvider.findConnectionType(),
                          sdkVersion: sdkInfo.version,
                          rnd: numberGenerator.nextIntForCache(),
                          type: .impressionDownloaded,
                          no_image: true,
                          data: nil)
    }
    
    func makeClickQuery(_ request: EventRequest) -> EventQuery {
        return EventQuery(placement: request.placementId,
                          bundle: sdkInfo.bundle,
                          creative: request.creativeId,
                          line_item: request.lineItemId,
                          ct: connectionProvider.findConnectionType(),
                          sdkVersion: sdkInfo.version,
                          rnd: numberGenerator.nextIntForCache(),
                          type: nil,
                          no_image: nil,
                          data: nil)
    }
    
    func makeVideoClickQuery(_ request: EventRequest) -> EventQuery {
        return EventQuery(placement: request.placementId,
                          bundle: sdkInfo.bundle,
                          creative: request.creativeId,
                          line_item: request.lineItemId,
                          ct: connectionProvider.findConnectionType(),
                          sdkVersion: sdkInfo.version,
                          rnd: numberGenerator.nextIntForCache(),
                          type: nil,
                          no_image: nil,
                          data: nil)
    }
    
    func makeEventQuery(_ request: EventRequest) -> EventQuery {
        let json = encoder.toJson(request.data)
        let encodedData = encoder.encodeUri(json)
        return EventQuery(placement: request.placementId,
                          bundle: sdkInfo.bundle,
                          creative: request.creativeId,
                          line_item: request.lineItemId,
                          ct: connectionProvider.findConnectionType(),
                          sdkVersion: sdkInfo.version,
                          rnd: numberGenerator.nextIntForCache(),
                          type: request.type,
                          no_image: nil,
                          data: encodedData)
    }
}
