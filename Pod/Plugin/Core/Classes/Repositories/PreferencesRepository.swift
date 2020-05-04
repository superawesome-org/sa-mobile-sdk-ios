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
        internal static let userAgent = "SuperAwesome.DataRepository.Keys.userAgent"
        internal static let dauUniqueId = "SuperAwesome.DataRepository.Keys.dauUniquePart"
    }
    
    private let dataSource: UserDefaults
    
    init(_ dataSource: UserDefaults) {
        self.dataSource = dataSource
    }
    
    public var userAgent: String? {
        get { return dataSource.string(forKey: Keys.userAgent) }
        set(newValue) { dataSource.set(newValue, forKey: Keys.userAgent) }
    }
    
    public var dauUniquePart: String? {
        get { return dataSource.string(forKey: Keys.dauUniqueId) }
        set(newValue) { dataSource.set(newValue, forKey: Keys.dauUniqueId) }
    }
}
