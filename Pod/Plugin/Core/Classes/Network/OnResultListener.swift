//
//  Completion.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 17/04/2020.
//

/// Callback function for success & failure results
typealias OnResultListener<T> = (_ result: Result<T, Error>) -> Void

/// Callback function for completable events
typealias OnCompleteListener<T> = (_ result: T) -> Void
