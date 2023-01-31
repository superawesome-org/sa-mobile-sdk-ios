//
//  AdRepository.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 17/04/2020.
//

protocol AdRepositoryType {
    func getAd(placementId: Int, request: AdRequest, completion: @escaping OnResult<AdResponse>)
    func getAd(placementId: Int,
               lineItemId: Int,
               creativeId: Int,
               request: AdRequest,
               completion: @escaping OnResult<AdResponse>)
}

class AdRepository: AdRepositoryType {
    private let dataSource: AwesomeAdsApiDataSourceType
    private let adQueryMaker: AdQueryMakerType
    private let adProcessor: AdProcessorType

    init(dataSource: AwesomeAdsApiDataSourceType,
         adQueryMaker: AdQueryMakerType,
         adProcessor: AdProcessorType) {
        self.dataSource = dataSource
        self.adQueryMaker = adQueryMaker
        self.adProcessor = adProcessor
    }

    func getAd(placementId: Int, request: AdRequest, completion: @escaping OnResult<AdResponse>) {
        let query = adQueryMaker.makeAdQuery(request)
        dataSource.getAd(placementId: placementId, query: query) { result in
            switch result {
            case .success(let ad):
                self.adProcessor.process(placementId, ad, request.queryOptions) { response in
                    completion(Result.success(response))
                }
            case .failure(let error): completion(Result.failure(error))
            }
        }
    }

    func getAd(placementId: Int, lineItemId: Int, creativeId: Int, request: AdRequest, completion: @escaping OnResult<AdResponse>) {
        let query = adQueryMaker.makeAdQuery(request)
        dataSource.getAd(placementId: placementId,
                         lineItemId: lineItemId,
                         creativeId: creativeId,
                         query: query) { result in
            switch result {
            case .success(let ad):
                self.adProcessor.process(placementId, ad, request.queryOptions) { response in
                    completion(Result.success(response))
                }
            case .failure(let error): completion(Result.failure(error))
            }
        }
    }
}
