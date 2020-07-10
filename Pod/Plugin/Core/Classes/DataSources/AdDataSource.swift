//
//  AdDataSource.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 23/04/2020.
//

protocol AdDataSourceType {
    func getAd(placementId: Int, query: AdQuery, completion: @escaping OnResultListener<Ad>)
    func impression(query: EventQuery, completion: @escaping OnResultListener<Void>)
    func click(query: EventQuery, completion: @escaping OnResultListener<Void>)
    func videoClick(query: EventQuery, completion: @escaping OnResultListener<Void>)
    func event(query: EventQuery, completion: @escaping OnResultListener<Void>)
}
