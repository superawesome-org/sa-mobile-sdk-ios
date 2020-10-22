//
//  AdQueryMaker.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 17/04/2020.
//

protocol AdQueryMakerType {
    func makeAdQuery(_ request: AdRequest) -> AdQuery
    func makeImpressionQuery(_ adResponse: AdResponse) -> EventQuery
    func makeClickQuery(_ adResponse: AdResponse) -> EventQuery
    func makeVideoClickQuery(_ adResponse: AdResponse) -> EventQuery
    func makeEventQuery(_ adResponse: AdResponse, _ eventData: EventData) -> EventQuery
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
    
    func makeImpressionQuery(_ adResponse: AdResponse) -> EventQuery {
        return EventQuery(placement: adResponse.placementId,
                          bundle: sdkInfo.bundle,
                          creative: adResponse.ad.creative.id,
                          line_item: adResponse.ad.line_item_id,
                          ct: connectionProvider.findConnectionType(),
                          sdkVersion: sdkInfo.version,
                          rnd: numberGenerator.nextIntForCache(),
                          type: .impressionDownloaded,
                          no_image: true,
                          data: nil)
    }
    
    func makeClickQuery(_ adResponse: AdResponse) -> EventQuery {
        return EventQuery(placement: adResponse.placementId,
                          bundle: sdkInfo.bundle,
                          creative: adResponse.ad.creative.id,
                          line_item: adResponse.ad.line_item_id,
                          ct: connectionProvider.findConnectionType(),
                          sdkVersion: sdkInfo.version,
                          rnd: numberGenerator.nextIntForCache(),
                          type: nil,
                          no_image: nil,
                          data: nil)
    }
    
    func makeVideoClickQuery(_ adResponse: AdResponse) -> EventQuery {
        return EventQuery(placement: adResponse.placementId,
                          bundle: sdkInfo.bundle,
                          creative: adResponse.ad.creative.id,
                          line_item: adResponse.ad.line_item_id,
                          ct: connectionProvider.findConnectionType(),
                          sdkVersion: sdkInfo.version,
                          rnd: numberGenerator.nextIntForCache(),
                          type: nil,
                          no_image: nil,
                          data: nil)
    }
    
    func makeEventQuery(_ adResponse: AdResponse, _ eventData: EventData) -> EventQuery {
        let json = encoder.toJson(eventData)
        let encodedData = encoder.encodeUri(json)
        return EventQuery(placement: adResponse.placementId,
                          bundle: sdkInfo.bundle,
                          creative: adResponse.ad.creative.id,
                          line_item: adResponse.ad.line_item_id,
                          ct: connectionProvider.findConnectionType(),
                          sdkVersion: sdkInfo.version,
                          rnd: numberGenerator.nextIntForCache(),
                          type: eventData.type,
                          no_image: nil,
                          data: encodedData)
    }
}
