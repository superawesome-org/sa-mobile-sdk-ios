//
//  GetPlacements.swift
//  SuperAwesomeSwiftUIExample
//
//  Created by Myles Eynon on 17/02/2023.
//

import Combine
import Foundation

class GetPlacements {

    private var root: String {
        if CommandLine.arguments.contains("--UITests") {
            return "http://localhost:8080"
        } else {
            return "https://aa-sdk.s3.eu-west-1.amazonaws.com"
        }
    }

    func loadFeatures() -> AnyPublisher<Features, Never>? {
        guard let url = URL(string: "\(root)/placements.json") else { return nil }
        let session = URLSession.shared
        let publisher = session.dataTaskPublisher(for: url)
            .tryMap { element -> Data in
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
