//
//  NetworkDataSourceMock.swift
//  SuperAwesome-Unit-Full-Tests
//
//  Created by Gunhan Sancar on 28/10/2020.
//

@testable import SuperAwesome

struct NetworkDataSourceMock: NetworkDataSourceType {
    let getDataResult: Result<Data, Error>
    let getDataResult2: Result<Data, Error>
    let downloadFileResult: Result<String, Error>
    
    func getData(url: String, completion: OnResult<Data>?) {
        completion?(url.contains("first") ? getDataResult : getDataResult2)
    }
    
    func downloadFile(url: String, completion: @escaping OnResult<String>) {
        completion(downloadFileResult)
    }
    
    func clearFiles() {
        
    }
}
