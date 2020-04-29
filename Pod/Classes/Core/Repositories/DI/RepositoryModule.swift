//
//  RepositoryModule.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 04/04/2020.
//

@objc(SARepositoryModuleType)
@available(*, deprecated, message: "Will be deleted")
public protocol RepositoryModuleObjcType {
    var dataRepository: DataRepositoryType { get }
}

class RepositoryModuleObjc: RepositoryModuleObjcType {
    lazy var dataRepository: DataRepositoryType = DataRepository(UserDefaults.standard)
}
