//
//  IdGenerator.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 20/04/2020.
//

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
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMyyyy"
        return formatter
    }()
    
    lazy var uniqueDauId: Int = { findDauId() }()
    
    init(preferencesRepository: PreferencesRepositoryType,
         sdkInfo: SdkInfoType,
         numberGenerator: NumberGeneratorType) {
        self.preferencesRepository = preferencesRepository
        self.sdkInfo = sdkInfo
        self.numberGenerator = numberGenerator
    }
    
    func findDauId() -> Int {
    
        let firstPart = dateFormatter.string(from: Date())
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
