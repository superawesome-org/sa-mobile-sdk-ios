//
//  NetworkDataSource.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 08/07/2020.
//

protocol NetworkDataSourceType {
    func getData(url: String, completion: @escaping OnResultListener<Data>)
    func downloadFile(url: String, completion: @escaping OnResultListener<String>)
}
