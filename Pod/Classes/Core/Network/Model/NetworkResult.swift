//
//  NetworkResult.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 16/04/2020.
//

public struct NetworkResult<T> {
    let isSuccess: Bool
    let response: T?
    let error: Error?
    
    static func success(_ response: T) -> NetworkResult<T> {
        NetworkResult(isSuccess: true, response: response, error: nil)
    }
    
    static func failure(_ error: Error) -> NetworkResult<T> {
        NetworkResult(isSuccess: false, response: nil, error: error)
    }
}
