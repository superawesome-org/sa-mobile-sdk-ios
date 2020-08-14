//
//  MoyaNetworkDataSource.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 06/07/2020.
//

import Alamofire

class MoyaNetworkDataSource {
    func get(_ url: String, completion: @escaping Completion<Data>) {
        AF.request(url).responseData { response in
            switch response.result {
            case .success: completion(Result.success(response.value ?? Data()))
            case .failure(let error): completion(Result.failure(error))
            }
        }
    }
}
