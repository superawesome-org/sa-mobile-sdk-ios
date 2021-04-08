//
//  AdProcessor.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 02/07/2020.
//

protocol AdProcessorType {
    func process(_ placementId: Int, _ ad: Ad, complition: @escaping OnComplete<AdResponse>)
}

class AdProcessor: AdProcessorType {
    private let htmlFormatter: HtmlFormatterType
    private let vastParser: VastParserType
    private let networkDataSource: NetworkDataSourceType
    
    init(htmlFormatter: HtmlFormatterType,
         vastParser: VastParserType,
         networkDataSource: NetworkDataSourceType) {
        self.htmlFormatter = htmlFormatter
        self.vastParser = vastParser
        self.networkDataSource = networkDataSource
    }
    
    func process(_ placementId: Int, _ ad: Ad, complition: @escaping OnComplete<AdResponse>) {
        let response = AdResponse(ad)
        
        switch ad.creative.format {
        case .image_with_link:
            response.html = htmlFormatter.formatImageIntoHtml(ad)
            complition(response)
        case .rich_media:
            response.html = htmlFormatter.formatRichMediaIntoHtml(placementId, ad)
            complition(response)
        case .tag:
            response.html = htmlFormatter.formatTagIntoHtml(ad)
            complition(response)
        case .video:
            if let url = ad.creative.details.vast {
                handleVast(url, initialVast: nil) { vast in
                    response.vast = vast
                    complition(response)
                }
            } else {
                complition(response)
            }
        }
    }
    
    private func handleVast(_ url: String, initialVast: VastAd?, complition: @escaping OnComplete<VastAd?>) {
        networkDataSource.getData(url: url) { result in
            switch result {
            case .success(let data):
                let vast = self.vastParser.parse(data)
                
                if let redirect = vast.redirect {
                    let mergedVast = vast.merge(from: initialVast)
                    self.handleVast(redirect, initialVast: mergedVast, complition: complition)
                } else {
                    complition(vast)
                }
            case .failure: complition(initialVast)
            }
        }
    }
}
