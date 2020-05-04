//
//  IdGenerator.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 20/04/2020.
//

import AdSupport

protocol IdGeneratorType {
    var uniqueDauId: Int { get }
}

class IdGenerator: IdGeneratorType {
    struct Keys {
        static let noTracking = 0
        static let dauLength = 32
    }
    
    private var preferencesRepository: PreferencesRepositoryType
    private let sdkInfo: SdkInfoType
    private let numberGenerator: NumberGeneratorType
    private let identifierManager: ASIdentifierManager
    
    lazy var uniqueDauId: Int = { findDauId() }()
    
    init(preferencesRepository: PreferencesRepositoryType,
         sdkInfo: SdkInfoType,
         numberGenerator: NumberGeneratorType,
         identifierManager: ASIdentifierManager) {
        self.preferencesRepository = preferencesRepository
        self.sdkInfo = sdkInfo
        self.numberGenerator = numberGenerator
        self.identifierManager = identifierManager
    }
    
    func findDauId() -> Int {
        guard identifierManager.isAdvertisingTrackingEnabled else { return Keys.noTracking }
        
        let firstPart = identifierManager.advertisingIdentifier.uuidString
        let secondPart = preferencesRepository.dauUniquePart ?? generateAndSavePartOfDau()
        let thirdPart = sdkInfo.bundle
        
        return firstPart.hash ^ secondPart.hash ^ thirdPart.hash
    }
    
    private func generateAndSavePartOfDau() -> String {
        let generatedNumber = numberGenerator.nextAlphanumericString(length: Keys.dauLength)
        preferencesRepository.dauUniquePart = generatedNumber
        return generatedNumber
    }
}
