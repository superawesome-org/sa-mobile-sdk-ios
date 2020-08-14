//
//  EventRepository.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 29/04/2020.
//

protocol EventRepositoryType {
    func impression(request: EventRequest, completion: @escaping OnResult<Void>)
    func click(request: EventRequest, completion: @escaping OnResult<Void>)
    func videoClick(request: EventRequest, completion: @escaping OnResult<Void>)
    func event(request: EventRequest, completion: @escaping OnResult<Void>)
}

class EventRepository : EventRepositoryType {
    private let dataSource: AdDataSourceType
    private let adQueryMaker: AdQueryMakerType
    
    init(dataSource: AdDataSourceType, adQueryMaker: AdQueryMakerType) {
        self.dataSource = dataSource
        self.adQueryMaker = adQueryMaker
    }
    
    func impression(request: EventRequest, completion: @escaping OnResult<Void>) {
        dataSource.impression(query: adQueryMaker.makeImpressionQuery(request),
                              completion: completion)
    }
    
    func click(request: EventRequest, completion: @escaping OnResult<Void>) {
        dataSource.click(query: adQueryMaker.makeClickQuery(request),
                         completion: completion)
    }
    
    func videoClick(request: EventRequest, completion: @escaping OnResult<Void>) {
        dataSource.videoClick(query: adQueryMaker.makeVideoClickQuery(request),
                              completion: completion)
    }
    
    func event(request: EventRequest, completion: @escaping OnResult<Void>) {
        dataSource.event(query: adQueryMaker.makeEventQuery(request),
                         completion: completion)
    }
}

