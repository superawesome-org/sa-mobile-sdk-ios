//
//  UrlSessionAwesomeAdsDataSource.swift
//  SuperAwesome
//
//  Created by Mark on 11/06/2021.
//

import Foundation

class UrlSessionAwesomeAdsDataSource: AwesomeAdsApiDataSourceType {
    private let environment: Environment
    private let userAgent: String

    init(environment: Environment, userAgentProvider: UserAgentProviderType) {
        self.environment = environment
        self.userAgent = userAgentProvider.name
    }

    func getAd(placementId: Int, query: AdQuery, completion: @escaping OnResult<Ad>) {
        get(endPoint: "/v2/ad/\(placementId)", params: query.toDictionary(), completion: completion)
    }

    func getAd(placementId: Int, lineItemId: Int, creativeId: Int, query: AdQuery, completion: @escaping OnResult<Ad>) {
        get(endPoint: "/v2/ad/\(lineItemId)/\(creativeId)", params: query.toDictionary(), completion: completion)
    }

    func impression(query: EventQuery, completion: OnResult<Void>?) {
        get(endPoint: "/v2/impression", params: query.params, completion: completion)
    }

    func click(query: EventQuery, completion: OnResult<Void>?) {
        get(endPoint: "/v2/click", params: query.params, completion: completion)
    }

    func videoClick(query: EventQuery, completion: OnResult<Void>?) {
        get(endPoint: "/v2/video/click", params: query.params, completion: completion)
    }

    func event(query: EventQuery, completion: OnResult<Void>?) {
        get(endPoint: "/v2/event", params: query.params, completion: completion)
    }

    func signature(lineItemId: Int, creativeId: Int, completion: @escaping OnResult<AdvertiserSignatureDTO>) {
        get(endPoint: "/v2/skadnetwork/sign/\(lineItemId)/\(creativeId)", params: [:], completion: completion)
    }

    func get(endPoint: String, params: [String: String], completion: OnResult<Void>?) {
        let queryItems: [URLQueryItem] = params.map {
            URLQueryItem(name: $0.key, value: $0.value )
        }
        var components = URLComponents(string: endPoint)!
        components.queryItems = queryItems
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.addValue(userAgent, forHTTPHeaderField: "User-Agent")
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let httpResponse = response as? HTTPURLResponse, (200..<299).contains(httpResponse.statusCode) {
                DispatchQueue.main.async {
                    completion?(.success(Void()))
                }
            } else {
                DispatchQueue.main.async {
                    completion?(.failure(AwesomeAdsError.network))
                }
            }
        }.resume()
    }

    private func get<R: Codable>(endPoint: String, params: [String: Any], completion: @escaping (Result<R, Error>) -> Void) {
        let queryItems: [URLQueryItem] = params.map {
            URLQueryItem(name: $0.key, value: String(describing: $0.value))
        }
        var components = URLComponents(string: environment.baseURL.absoluteString)!
        print(environment.baseURL.absoluteString)
        components.path = endPoint
        components.queryItems = queryItems
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.addValue( "application/json", forHTTPHeaderField: "Content-type")
        request.addValue(userAgent, forHTTPHeaderField: "User-Agent")
        URLSession.shared.dataTask(with: request) { data, response, _ in
            if let data = data,
               let httpResponse = response as? HTTPURLResponse, (200..<299).contains(httpResponse.statusCode),
               let object = try? JSONDecoder().decode(R.self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(object))
                }
            } else {
                let str = data != nil ? String(data: data!, encoding: .utf8) ?? "" : ""
                DispatchQueue.main.async {
                    completion(.failure(AwesomeAdsError.jsonNotFound(json: str, endPoint: components.url?.absoluteString ?? "")))
                }
            }
        }.resume()
    }
}
