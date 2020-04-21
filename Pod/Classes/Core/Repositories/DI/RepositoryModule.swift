//
//  RepositoryModule.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 04/04/2020.
//

import Moya

@objc(SARepositoryModuleType)
@available(*, deprecated, message: "Will be deleted")
public protocol RepositoryModuleObjcType {
    var dataRepository: DataRepositoryType { get }
}

class RepositoryModuleObjc: RepositoryModuleObjcType {
    lazy var dataRepository: DataRepositoryType = DataRepository(UserDefaults.standard)
}

protocol RepositoryModuleType {
    func resolve() -> DataRepositoryType
    func resolve() -> AdRepositoryType
}

class RepositoryModule: RepositoryModuleType {
    private var networkModule: NetworkModuleType
    private lazy var dataRepository: DataRepositoryType = DataRepository(UserDefaults.standard)
    private lazy var adRepositroy: AdRepositoryType = AdRepository(networkModule.resolve(),
                                                           adQueryMaker: networkModule.resolve())
    
    init(_ networkModule: NetworkModuleType) {
        self.networkModule = networkModule
    }
    
    func resolve() -> DataRepositoryType { dataRepository }
    func resolve() -> AdRepositoryType { adRepositroy }
}
