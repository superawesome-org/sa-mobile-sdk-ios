//
//  GetPlacements.swift
//  SuperAwesomeSwiftUIExample
//
//  Created by Myles Eynon on 17/02/2023.
//

import Combine
import Foundation

class GetPlacements {

    private let root = "https://aa-sdk.s3.eu-west-1.amazonaws.com"

//    func load(completion: @escaping (([FeatureItem]?, Error?) -> Void)) {
//        guard let url = URL(string: "\(root)/placements.json") else { return }
//        let session = URLSession.shared
//        var request = URLRequest(url: url)
//        let task = session.dataTask(with: request) { data, response, error in
//            if let data = data {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                guard let features = try? decoder.decode([FeatureItem].self, from: data) else { return }
//                completion(features, nil)
//            } else if let error = error {
//                print("HTTP Request Failed \(error)")
//                completion(nil, error)
//            }
//        }
//        task.resume()
//    }

    func loadFeatures() -> AnyPublisher<Features, Never>? {
        guard let url = URL(string: "\(root)/placements.json") else { return nil }
        let session = URLSession.shared
        let publisher = session.dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: Features.self, decoder: JSONDecoder())
            .replaceError(with: Features(features: []))
            .eraseToAnyPublisher()

        return publisher
    }
}
