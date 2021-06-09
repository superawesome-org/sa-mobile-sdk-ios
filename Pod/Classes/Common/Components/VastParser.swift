//
//  VastParser.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 01/09/2020.
//

import SwiftyXMLParser

class VastParser: NSObject, VastParserType {

    private let connectionProvider: ConnectionProviderType

    init(connectionProvider: ConnectionProviderType) {
        self.connectionProvider = connectionProvider
    }

    func parse(_ data: Data) -> VastAd? {

        let xml = XML.parse(data)
        var root: XML.Accessor

        var type: VastType!
        if xml.VAST.Ad.InLine.error == nil {
            type = .inLine
            root = xml.VAST.Ad.InLine
        } else if xml.VAST.Ad.Wrapper.error == nil {
            type = .wrapper
            root = xml.VAST.Ad.Wrapper
        } else {
            return nil
        }

        let redirect = root.VASTAdTagURI.text

        var errors: [String] = []
        if let value = root.Error.text {
            errors = [value]
        }

        var impressions: [String] = []
        if let value = root.Impression.text {
            impressions = [value]
        }

        var clickThrough: String?
        var clickTrackingEvents = [String]()
        var creativeViews = [String]()
        var startEvents = [String]()
        var firstQuartiles = [String]()
        var midPoints = [String]()
        var thirdQuartiles = [String]()
        var completes = [String]()
        var medias = [VastMedia]()

        for linear in root.Creatives.Creative.Linear {
            clickThrough = linear.VideoClicks.ClickThrough.iterateValues().map { $0 }.last
            clickTrackingEvents.append(contentsOf: linear.VideoClicks.ClickTracking.iterateValues().map { $0 })

            for tracking in linear.TrackingEvents.Tracking {
                if let event = tracking.attributes["event"], let url = tracking.text, !url.isEmpty {
                    switch event {
                    case "creativeView": creativeViews.append(url)
                    case "start": startEvents.append(url)
                    case "firstQuartile": firstQuartiles.append(url)
                    case "midpoint": midPoints.append(url)
                    case "thirdQuartile": thirdQuartiles.append(url)
                    case "complete": completes.append(url)
                    default: continue
                    }
                }

            }

            for media in linear.MediaFiles.MediaFile {
                if let type = media.attributes["type"],
                   type.contains("mp4"),
                   let url = media.text,
                   let bitrate = media.attributes["bitrate"]?.toInt,
                   let width = media.attributes["width"]?.toInt,
                   let height = media.attributes["height"]?.toInt {
                    medias.append(VastMedia(type: type, url: url, bitrate: bitrate, width: width, height: height))
                }
            }
        }
        return VastAd(
            url: getUrl(medias: medias),
            type: type,
            redirect: redirect,
            errorEvents: errors,
            impressions: impressions,
            clickThrough: clickThrough,
            creativeViewEvents: creativeViews,
            startEvents: startEvents,
            firstQuartileEvents: firstQuartiles,
            midPointEvents: midPoints,
            thirdQuartileEvents: thirdQuartiles,
            completeEvents: completes,
            clickTrackingEvents: clickTrackingEvents,
            media: medias
        )
    }

    func getUrl(medias: [VastMedia]) -> String? {
        let sortedMedias = medias.sorted { (first, second) -> Bool in
            first.bitrate ?? 0 < second.bitrate ?? 0
        }
        var url: String?
        let quality = connectionProvider.findConnectionType().findQuality()
        switch quality {
        case .minumum: url = sortedMedias.first?.url
        case .medium:
            let size = sortedMedias.count
            if size > 2 {
               url = sortedMedias[size/2].url
            } else {
                url = sortedMedias.last?.url
            }
        case .maximum: url = sortedMedias.last?.url
        }

        if url == nil && medias.count > 0 {
            url = medias.last?.url
        }
        return url
    }
}

extension XML.Accessor {
    func iterateValues() -> [String] {
        var result = [String]()
        for item in self {
            if let value = item.text {
                result.append(value)
            }
        }
        return result
    }
}
