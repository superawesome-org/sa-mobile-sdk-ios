//
//  RepositoryModule.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 04/04/2020.
//

import Moya

@objc(SARepositoryModuleType)
public protocol RepositoryModuleObjcType {
    var dataRepository: DataRepositoryType { get }
}

class RepositoryModuleObjc: RepositoryModuleObjcType {
    lazy var dataRepository: DataRepositoryType = DataRepository(UserDefaults.standard)
}

protocol RepositoryModuleType {
    var dataRepository: DataRepositoryType { get }
    var adRepositroy: AdRepositoryType { get }
}

class RepositoryModule: RepositoryModuleType {
    lazy var dataRepository: DataRepositoryType = DataRepository(UserDefaults.standard)
    lazy var adRepositroy: AdRepositoryType = AdRepository(provider, adQueryMaker: adQueryMaker)
    
    private let provider: MoyaProvider<AwesomeAdsTarget>
    private let adQueryMaker: AdQueryMakerType
    
    init(provider: MoyaProvider<AwesomeAdsTarget>, adQueryMaker: AdQueryMakerType) {
        self.provider = provider
        self.adQueryMaker = adQueryMaker
    }
}
