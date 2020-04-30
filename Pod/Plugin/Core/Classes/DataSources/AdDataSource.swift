//
//  AdDataSource.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 23/04/2020.
//

protocol AdDataSourceType {
    func getAd(environment: Environment, placementId: Int, query: AdQuery, completion: @escaping Completion<Ad>)
    func impression(environment: Environment, query: EventQuery, completion: @escaping Completion<Void>)
    func click(environment: Environment, query: EventQuery, completion: @escaping Completion<Void>)
    func videoClick(environment: Environment, query: EventQuery, completion: @escaping Completion<Void>)
    func event(environment: Environment, query: EventQuery, completion: @escaping Completion<Void>)
}
