//
//  DataPersistance.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 03/04/2020.
//


import Foundation

public protocol DataRepositoryType {
    var userAgent: String? { get set }
}

public class DataRepository : NSObject, DataRepositoryType {
    private let userAgentKey = "SuperAwesome.Keys.UserAgent"
    
    public var userAgent: String? {
        get { return UserDefaults.standard.string(forKey: userAgentKey) }
        set(newValue) { UserDefaults.standard.set(newValue, forKey: userAgentKey) }
    }
}
