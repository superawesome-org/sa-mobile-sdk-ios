//
//  MoyaAdDataSource.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 23/04/2020.
//

import Moya

class MoyaAwesomeAdsApiDataSource: AwesomeAdsApiDataSourceType {
    
    private let provider: MoyaProvider<AwesomeAdsTarget>
    private let environment: Environment
    private let retryDelay: TimeInterval
    
    init(provider: MoyaProvider<AwesomeAdsTarget>, environment: Environment, retryDelay: TimeInterval) {
        self.provider = provider
        self.environment = environment
        self.retryDelay = retryDelay
    }
    
    func getAd(placementId: Int, query: QueryBundle, completion: @escaping OnResult<Ad>) {
        let target = AwesomeAdsTarget(environment, .ad(placementId: placementId, query: query))
        
        provider.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    let result = try filteredResponse.map(Ad.self)
                    completion(Result.success(result))
                } catch let error {
                    completion(Result.failure(error))
                }
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
    
    func getAd(placementId: Int,
               lineItemId: Int,
               creativeId: Int,
               query: QueryBundle,
               completion: @escaping OnResult<Ad>) {
        let target = AwesomeAdsTarget(
            environment,
            .adByPlacementLineAndCreativeId(
                placementId: placementId,
                lineItemId: lineItemId,
                creativeId: creativeId,
                query: query
            )
        )
        
        provider.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    let result = try filteredResponse.map(Ad.self)
                    completion(Result.success(result))
                } catch let error {
                    completion(Result.failure(error))
                }
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
    
    func signature(lineItemId: Int, creativeId: Int, completion: @escaping (Result<AdvertiserSignatureDTO, Error>) -> Void) {
        let target = AwesomeAdsTarget(environment, .signature(lineItemId: lineItemId, creativeId: creativeId))
        
        provider.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    let result = try filteredResponse.map(AdvertiserSignatureDTO.self)
                    completion(Result.success(result))
                } catch let error {
                    completion(Result.failure(error))
                }
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
    
    func impression(query: QueryBundle, completion: OnResult<Void>?) {
        let target = AwesomeAdsTarget(environment, .impression(query: query))
        responseHandler(target: target, completion: completion)
    }
    
    func click(query: QueryBundle, completion: OnResult<Void>?) {
        let target = AwesomeAdsTarget(environment, .click(query: query))
        responseHandler(target: target, completion: completion)
    }
    
    func videoClick(query: QueryBundle, completion: OnResult<Void>?) {
        let target = AwesomeAdsTarget(environment, .videoClick(query: query))
        responseHandler(target: target, completion: completion)
    }
    
    func event(query: QueryBundle, completion: OnResult<Void>?) {
        let target = AwesomeAdsTarget(environment, .event(query: query))
        responseHandler(target: target, completion: completion)
    }
    
    private func responseHandler(target: AwesomeAdsTarget, completion: OnResult<Void>?) {
        var retries = 0
        let delay = retryDelay
        
        func innerRequest() {
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        _ = try response.filterSuccessfulStatusCodes()
                        completion?(Result.success(Void()))
                    } catch let error {
                        // If the server responds with a 4xx or 5xx error
                        completion?(Result.failure(error))
                    }
                case .failure(let error):
                    // This means there was a network failure
                    // - either the request wasn't sent (connectivity),
                    // - or no response was received (server timed out)
                    if retries < Constants.numberOfRetries {
                        retries += 1
                        DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                            innerRequest()
                        }
                    } else {
                        completion?(Result.failure(error))
                    }
                }
            }
        }
        
        innerRequest()
    }
}
