//
//  FeaturesViewModel.swift
//  SuperAwesomeSwiftUIExample
//
//  Created by Myles Eynon on 17/02/2023.
//

import Combine
import Foundation

class FeaturesViewModel: ObservableObject {

    @Published
    var features: Features = Features(features: [])

    private lazy var featuresPublisher: AnyPublisher<Features, Never>? = {
        GetPlacements()
            .loadFeatures()?
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }()

    init() {
        featuresPublisher?
            .assign(to: &$features)
    }
}
