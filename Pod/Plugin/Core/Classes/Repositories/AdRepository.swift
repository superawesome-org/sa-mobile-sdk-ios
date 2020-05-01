//
//  AdRepository.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 17/04/2020.
//

protocol AdRepositoryType {
    func getAd(placementId: Int, request: AdRequest, completion: @escaping Completion<Ad>)
}

class AdRepository : AdRepositoryType {
    private let dataSource: AdDataSourceType
    private let adQueryMaker: AdQueryMakerType
    
    init(dataSource: AdDataSourceType, adQueryMaker: AdQueryMakerType) {
        self.dataSource = dataSource
        self.adQueryMaker = adQueryMaker
    }
    
    func getAd(placementId: Int, request: AdRequest, completion: @escaping Completion<Ad>) {
        dataSource.getAd(placementId: placementId,
                         query: adQueryMaker.makeAdQuery(request),
                         completion: completion)
    }
}
