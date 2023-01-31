//
//  AdProcessor.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 02/07/2020.
//

protocol AdProcessorType {
    /// Processes the  given `ad` and creates and `HTML` or `VAST` fields.
    ///
    /// - Parameter placementId: Used while forming HTML tags
    /// - Parameter ad: The `Ad` object to be processed
    /// - Parameter requestOptions: The additional data that was sent with the ad's request. Should be nil if no additional data was sent.
    /// - Parameter completion: Callback closure to be notified once the process is completed
    /// - Returns: `AdResponse` object which contains `HTML` or `VAST` fields to be shown
    func process(_ placementId: Int, _ ad: Ad, _ requestOptions: [String: String]?, completion: @escaping OnComplete<AdResponse>)
}

class AdProcessor: AdProcessorType {
    private let htmlFormatter: HtmlFormatterType
    private let vastParser: VastParserType
    private let networkDataSource: NetworkDataSourceType
    private let logger: LoggerType

    init(htmlFormatter: HtmlFormatterType,
         vastParser: VastParserType,
         networkDataSource: NetworkDataSourceType,
         logger: LoggerType) {
        self.htmlFormatter = htmlFormatter
        self.vastParser = vastParser
        self.networkDataSource = networkDataSource
        self.logger = logger
    }

    func process(_ placementId: Int, _ ad: Ad, _ requestOptions: [String: String]?, completion: @escaping OnComplete<AdResponse>) {
        let response = AdResponse(placementId, ad, requestOptions)

        switch ad.creative.format {
        case .imageWithLink:
            response.html = htmlFormatter.formatImageIntoHtml(ad)
            response.baseUrl = ad.creative.details.image?.baseUrl
            completion(response)
        case .richMedia:
            response.html = htmlFormatter.formatRichMediaIntoHtml(placementId, ad)
            response.baseUrl = (ad.creative.details.url ?? Constants.defaultBaseUrl).baseUrl
            completion(response)
        case .tag:
            response.html = htmlFormatter.formatTagIntoHtml(ad)
            response.baseUrl = Constants.defaultBaseUrl
            completion(response)
        case .video:
            if let url = ad.creative.details.vast {
                handleVast(url, initialVast: nil) { vast in
                    response.vast = vast
                    response.baseUrl = (vast?.url ??? Constants.defaultBaseUrl).baseUrl

                    self.networkDataSource.downloadFile(url: vast?.url ?? "",
                                                        completion: { result in
                        switch result {
                        case .success(let localFilePath):
                            response.filePath = localFilePath
                            completion(response)
                        case .failure: completion(response)
                        }
                    })
                }
            } else {
                completion(response)
            }
        case .unknown: completion(response)
        }
    }

    private func handleVast(_ url: String, initialVast: VastAd?, isRedirect: Bool = false, complition: @escaping OnComplete<VastAd?>) {
        networkDataSource.getData(url: url) { result in
            switch result {
            case .success(let data):
                let vast = self.vastParser.parse(data)
                if let redirect = vast?.redirect, !isRedirect {
                    let mergedVast = vast?.merge(from: initialVast)
                    self.handleVast(redirect, initialVast: mergedVast, isRedirect: true, complition: complition)
                } else {
                    let mergedVast = vast?.merge(from: initialVast)
                    complition(mergedVast)
                }
            case .failure: complition(initialVast)
            }
        }
    }
}
