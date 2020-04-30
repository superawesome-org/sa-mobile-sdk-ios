//
//  MoyaAdDataSource.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 23/04/2020.
//

import Moya

class MoyaAdDataSource: AdDataSourceType {
    let provider: MoyaProvider<AwesomeAdsTarget>
    
    init(_ provider: MoyaProvider<AwesomeAdsTarget>) {
        self.provider = provider
    }
    
    func getAd(environment: Environment, placementId: Int, query: AdQuery, completion: @escaping Completion<Ad>) {
        let target = AwesomeAdsTarget(environment, .ad(placementId: placementId, query: query))
        
        provider.request(target) { result in
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
    
    func impression(environment: Environment, query: EventQuery, completion: @escaping Completion<Void>) {
        let target = AwesomeAdsTarget(environment, .impression(query: query))
        responseHandler(target: target, completion: completion)
    }
    
    func click(environment: Environment, query: EventQuery, completion: @escaping Completion<Void>) {
        let target = AwesomeAdsTarget(environment, .click(query: query))
        responseHandler(target: target, completion: completion)
    }
    
    func videoClick(environment: Environment, query: EventQuery, completion: @escaping Completion<Void>) {
        let target = AwesomeAdsTarget(environment, .videoClick(query: query))
        responseHandler(target: target, completion: completion)
    }
    
    func event(environment: Environment, query: EventQuery, completion: @escaping Completion<Void>) {
        let target = AwesomeAdsTarget(environment, .event(query: query))
        responseHandler(target: target, completion: completion)
    }
    
    private func responseHandler(target: AwesomeAdsTarget, completion: @escaping Completion<Void>) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    completion(Result.success(Void()))
                } catch let error{
                    completion(Result.failure(error))
                }
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
}
