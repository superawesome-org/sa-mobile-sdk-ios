//
//  NetworkResult.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 16/04/2020.
//

public struct NetworkResult<T> {
    var isSuccess: Bool
    var response: T?
    var error: Error?
    
    static func success(_ response: T) -> NetworkResult<T> {
        return NetworkResult(isSuccess: true, response: response, error: nil)
    }
    
    static func failure(_ error: Error) -> NetworkResult<T> {
        return NetworkResult(isSuccess: false, response: nil, error: error)
    }
}
