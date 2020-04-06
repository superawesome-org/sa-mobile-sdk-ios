//
//  DataPersistance.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 03/04/2020.
//


import Foundation

@objc(SADataRepositoryType)
public protocol DataRepositoryType {
    var userAgent: String? { get set }
}

@objc(SADataRepository)
class DataRepository : NSObject, DataRepositoryType {
    private let userAgentKey = "SuperAwesome.Keys.UserAgent"

    private let dataSource: UserDefaults
    
    init(_ dataSource:UserDefaults) {
        self.dataSource = dataSource
    }
    
    public var userAgent: String? {
        get { return dataSource.string(forKey: userAgentKey) }
        set(newValue) { dataSource.set(newValue, forKey: userAgentKey) }
    }
}
