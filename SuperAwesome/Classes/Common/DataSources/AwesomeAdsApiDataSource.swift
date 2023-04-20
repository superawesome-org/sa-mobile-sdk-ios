//
//  AdDataSource.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 23/04/2020.
//

/// `AwesomeAdsDataSource` is used to make request to `AwesomeAds` API
protocol AwesomeAdsApiDataSourceType {
    /// Makes a request to `/ad` endpoint to retrieve an Ad object for the given `placementId`
    func getAd(placementId: Int, query: QueryBundle, completion: @escaping OnResult<Ad>)

    /// Makes a request to `/ad/{placementId}/{lineItemId}/{creativeId}` endpoint to retrieve an Ad object for the given `placementId`
    func getAd(placementId: Int,
               lineItemId: Int,
               creativeId: Int,
               query: QueryBundle,
               completion: @escaping OnResult<Ad>)

    /// Makes a request to `/impression` endpoint to trigger an impression event
    func impression(query: QueryBundle, completion: OnResult<Void>?)

    /// Makes a request to `/click` endpoint to trigger an click event
    func click(query: QueryBundle, completion: OnResult<Void>?)

    /// Makes a request to `/video/click` endpoint to trigger an video click event
    func videoClick(query: QueryBundle, completion: OnResult<Void>?)

    /// Makes a request to `/event` endpoint to trigger an custom event
    func event(query: QueryBundle, completion: OnResult<Void>?)

    func signature(lineItemId: Int, creativeId: Int, completion: @escaping OnResult<AdvertiserSignatureDTO>)
}
