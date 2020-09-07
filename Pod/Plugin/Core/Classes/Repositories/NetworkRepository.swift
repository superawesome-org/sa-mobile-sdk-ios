//
//  NetworkRepository.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 06/07/2020.
//

protocol NetworkRepositoryType {
        func getData(url: String, completion: @escaping OnResult<Data>)
    
    func downloadFile(url: String, completion: @escaping OnResult<String>)
}

class NetworkRepository: NetworkRepositoryType {
    private let dataSource: NetworkDataSourceType
    
    init(dataSource: NetworkDataSourceType) {
        self.dataSource = dataSource
    }
    
    func getData(url: String, completion: @escaping OnResult<Data>) {
        
    }
    
    func downloadFile(url: String, completion: @escaping OnResult<String>) {
        
    }
}
