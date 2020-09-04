//
//  AdDataSource.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 23/04/2020.
//

/// `AwesomeAdsDataSource` is used to make request to `AwesomeAds` API
protocol AwsomeAdsDataSourceType {
    /// Makes a request to `/ad` endpoint to retrieve an Ad object for the given `placementId`
    func getAd(placementId: Int, query: AdQuery, completion: @escaping OnResult<Ad>)
    
    /// Makes a request to `/impression` endpoint to trigger an impression event
    func impression(query: EventQuery, completion: OnResult<Void>?)
    
    /// Makes a request to `/impression` endpoint to trigger an click event
    func click(query: EventQuery, completion: OnResult<Void>?)
    
    /// Makes a request to `/impression` endpoint to trigger an video click event
    func videoClick(query: EventQuery, completion: OnResult<Void>?)
    
    /// Makes a request to `/impression` endpoint to trigger an custom event
    func event(query: EventQuery, completion: OnResult<Void>?)
}
