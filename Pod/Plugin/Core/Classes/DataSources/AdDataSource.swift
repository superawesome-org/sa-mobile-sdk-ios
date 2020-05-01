//
//  AdDataSource.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 23/04/2020.
//

protocol AdDataSourceType {
    func getAd(placementId: Int, query: AdQuery, completion: @escaping Completion<Ad>)
    func impression(query: EventQuery, completion: @escaping Completion<Void>)
    func click(query: EventQuery, completion: @escaping Completion<Void>)
    func videoClick(query: EventQuery, completion: @escaping Completion<Void>)
    func event(query: EventQuery, completion: @escaping Completion<Void>)
}
