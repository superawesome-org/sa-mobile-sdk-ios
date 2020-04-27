//
//  AdRepository.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 17/04/2020.
//

protocol AdRepositoryType {
    func getAd(placementId: Int, request: AdRequest, completion: @escaping Completion<Ad>)
}

class AdRepository : AdRepositoryType {
    private let dataSource: AdDataSourceType
    
    init(_ dataSource: AdDataSourceType) {
        self.dataSource = dataSource
    }
    
    func getAd(placementId: Int, request: AdRequest, completion: @escaping Completion<Ad>) {
        dataSource.getAd(placementId: placementId, request: request, completion: completion)
    }
}
