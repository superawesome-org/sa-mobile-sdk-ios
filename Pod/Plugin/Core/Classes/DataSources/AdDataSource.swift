//
//  AdDataSource.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 23/04/2020.
//

protocol AdDataSourceType {
    func getAd(placementId: Int, request: AdRequest, completion: @escaping Completion<Ad>)
}
