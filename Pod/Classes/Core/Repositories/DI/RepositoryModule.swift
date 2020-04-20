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

class RepositoryModule: RepositoryModuleType, Injectable {
    private lazy var networkModule: NetworkModuleType = dependencies.resolve()
    private lazy var componentModule: ComponentModuleType = dependencies.resolve()
    private lazy var dataRepository: DataRepositoryType = DataRepository(UserDefaults.standard)
    private lazy var adRepositroy: AdRepositoryType = AdRepository(networkModule.resolve(),
                                                           adQueryMaker: componentModule.resolve())
    
    func resolve() -> DataRepositoryType { dataRepository }
    func resolve() -> AdRepositoryType { adRepositroy }
}
