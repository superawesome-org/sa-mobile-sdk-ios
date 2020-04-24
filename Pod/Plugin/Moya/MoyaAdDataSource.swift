//
//  MoyaAdDataSource.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 23/04/2020.
//

import Moya

class MoyaAdDataSource: AdDataSourceType {
    let provider: MoyaProvider<AwesomeAdsTarget>
    let adQueryMaker: AdQueryMakerType
    
    init(_ provider: MoyaProvider<AwesomeAdsTarget>, adQueryMaker: AdQueryMakerType) {
        self.provider = provider
        self.adQueryMaker = adQueryMaker
    }
    
    func getAd(placementId: Int, request: AdRequest, completion: @escaping Completion<Ad>) {
        let endpoint = AwesomeAdsApi.ad(placementId: placementId, query: adQueryMaker.make(request))

        provider.request(request.environment.make(endpoint)) { result in
            switch result {
            case .success(let response):
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    let result = try filteredResponse.map(Ad.self)
                    completion(Result.success(result))
                } catch let error{
                    completion(Result.failure(error))
                }
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
}
