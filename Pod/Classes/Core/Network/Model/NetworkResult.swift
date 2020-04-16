//
//  NetworkResult.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 16/04/2020.
//

struct NetworkResult<T> {
    var isSuccess: Bool
    var response: T?
    var error: Error?
}
