//
//  Completion.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 17/04/2020.
//

/// Network call completion closure definition
typealias Completion<T> = (_ result: Result<T, Error>) -> Void
