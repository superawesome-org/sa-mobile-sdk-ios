//
//  EventRepository.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 29/04/2020.
//

protocol EventRepositoryType {
    func impression(_ adResponse: AdResponse, completion: OnResult<Void>?)
    func click(_ adResponse: AdResponse, completion: OnResult<Void>?)
    func videoClick(_ adResponse: AdResponse, completion: OnResult<Void>?)
    func parentalGateOpen(_ adResponse: AdResponse, completion: OnResult<Void>?)
    func parentalGateClose(_ adResponse: AdResponse, completion: OnResult<Void>?)
    func parentalGateSuccess(_ adResponse: AdResponse, completion: OnResult<Void>?)
    func parentalGateFail(_ adResponse: AdResponse, completion: OnResult<Void>?)
    func viewableImpression(_ adResponse: AdResponse, completion: OnResult<Void>?)
}

class EventRepository: EventRepositoryType {
    private let dataSource: AwesomeAdsApiDataSourceType
    private let adQueryMaker: AdQueryMakerType

    init(dataSource: AwesomeAdsApiDataSourceType, adQueryMaker: AdQueryMakerType) {
        self.dataSource = dataSource
        self.adQueryMaker = adQueryMaker
    }

    func impression(_ adResponse: AdResponse, completion: OnResult<Void>?) {
        dataSource.impression(query: adQueryMaker.makeImpressionQuery(adResponse), completion: completion)
    }

    func click(_ adResponse: AdResponse, completion: OnResult<Void>?) {
        dataSource.click(query: adQueryMaker.makeClickQuery(adResponse), completion: completion)
    }

    func videoClick(_ adResponse: AdResponse, completion: OnResult<Void>?) {
        dataSource.videoClick(query: adQueryMaker.makeVideoClickQuery(adResponse), completion: completion)
    }

    func parentalGateOpen(_ adResponse: AdResponse, completion: OnResult<Void>?) {
        customEvent(.parentalGateOpen, adResponse, completion: completion)
    }

    func parentalGateClose(_ adResponse: AdResponse, completion: OnResult<Void>?) {
        customEvent(.parentalGateClose, adResponse, completion: completion)
    }

    func parentalGateSuccess(_ adResponse: AdResponse, completion: OnResult<Void>?) {
        customEvent(.parentalGateSuccess, adResponse, completion: completion)
    }

    func parentalGateFail(_ adResponse: AdResponse, completion: OnResult<Void>?) {
        customEvent(.parentalGateFail, adResponse, completion: completion)
    }

    func viewableImpression(_ adResponse: AdResponse, completion: OnResult<Void>?) {
        customEvent(.viewableImpression, adResponse, completion: completion)
    }

    private func customEvent(_ type: EventType, _ adResponse: AdResponse, completion: OnResult<Void>?) {
        let data = EventData(placement: adResponse.placementId,
                             lineItem: adResponse.advert.lineItemId,
                             creative: adResponse.advert.creative.id,
                             type: type)
        dataSource.event(query: adQueryMaker.makeEventQuery(adResponse, data), completion: completion)
    }
}
