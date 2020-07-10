//
//  AdRepository.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 17/04/2020.
//

protocol AdRepositoryType {
    func getAd(placementId: Int, request: AdRequest, completion: @escaping OnResultListener<Ad>)
}

class AdRepository : AdRepositoryType {
    private let dataSource: AdDataSourceType
    private let adQueryMaker: AdQueryMakerType
    private let adProcessor: AdProcessorType
    
    init(dataSource: AdDataSourceType,
         adQueryMaker: AdQueryMakerType,
         adProcessor: AdProcessorType) {
        self.dataSource = dataSource
        self.adQueryMaker = adQueryMaker
        self.adProcessor = adProcessor
    }
    
    func getAd(placementId: Int, request: AdRequest, completion: @escaping OnResultListener<Ad>) {
        dataSource.getAd(placementId: placementId,
                         query: adQueryMaker.makeAdQuery(request)) { result in
                            if case .success(let ad) = result {
                                self.adProcessor.process(ad) { response in
                                    
                                }
                            } else {
                                completion(result)
                            }
        }
    }
}
