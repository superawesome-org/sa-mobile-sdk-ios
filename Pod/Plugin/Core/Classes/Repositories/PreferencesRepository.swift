//
//  LocalDataPersistance.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 03/04/2020.
//


import Foundation

protocol PreferencesRepositoryType {
    var userAgent: String? { get set }
    var dauUniquePart: String? { get set }
}

class PreferencesRepository : PreferencesRepositoryType {
    struct Keys {
        internal static let userAgent = "AwesomeAds.PreferencesRepository.Keys.userAgent"
        internal static let dauUniqueId = "AwesomeAds.PreferencesRepository.Keys.dauUniquePart"
    }
    
    private let dataSource: UserDefaults
    
    init(_ dataSource: UserDefaults) {
        self.dataSource = dataSource
    }
    
    public var userAgent: String? {
        get { dataSource.string(forKey: Keys.userAgent) }
        set(newValue) { dataSource.set(newValue, forKey: Keys.userAgent) }
    }
    
    public var dauUniquePart: String? {
        get { dataSource.string(forKey: Keys.dauUniqueId) }
        set(newValue) { dataSource.set(newValue, forKey: Keys.dauUniqueId) }
    }
}
