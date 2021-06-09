//
//  NativeVastPasser.swift
//  SuperAwesome
//
//  Created by Mark on 09/06/2021.
//

import UIKit

final class NativeVastPasser: NSObject, VastParserType {
    private var vastAd: VastAd?

    private var currentElements: [String] = []
    private let connectionProvider: ConnectionProviderType

    private  var type: VastType! = .invalid
    private  var redirect: String?
    private  var errors: [String] = []
    private  var impressions: [String] = []
    private  var clickThrough: String?
    private  var clickTrackingEvents = [String]()
    private  var creativeViews = [String]()
    private  var startEvents = [String]()
    private  var firstQuartiles = [String]()
    private  var midPoints = [String]()
    private  var thirdQuartiles = [String]()
    private  var completes = [String]()
    private  var medias = [VastMedia]()
    private var event: String?
    private var currentMedia: VastMedia?
    private var trackingUrl: String = ""

    private var clickTrackingUrl = ""
    private var impressionsUrl = ""
    private var errorUrl = ""
    private var mediaUrl = ""

    init(connectionProvider: ConnectionProviderType) {
        self.connectionProvider = connectionProvider
    }

    func parse(_ data: Data) -> VastAd? {
        let decoder = XMLParser(data: data)
        decoder.delegate = self
        decoder.parse()
        return vastAd
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

extension NativeVastPasser: XMLParserDelegate {

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {

        if type == .invalid && currentElements.contains("Ad") {
            if elementName == "InLine" {
                type = .inLine
            } else if elementName == "Wrapper" {
                type = .wrapper
            }
        }
        if elementName == "Creatives"{
            currentElements = []
        }
        currentElements.append(elementName)
        if let event = attributeDict["event"] {
            self.event = event
        }
        if elementName == "MediaFile"{
            let bitRate = attributeDict["bitrate"] != nil ? Int(attributeDict["bitrate"]!) : nil
            let height = attributeDict["height"] != nil ? Int(attributeDict["height"]!) : nil
            let width = attributeDict["width"] != nil ? Int(attributeDict["width"]!) : nil
            currentMedia = VastMedia(type: attributeDict["type"], url: attributeDict["url"], bitrate: bitRate, width: width, height: height)
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

        if currentElements.count >= 2 {
            currentElements.removeFirst()
        }
        if currentElements.last == "Tracking" {
            print("___mark \(event) \(trackingUrl)")
            switch event {
            case "creativeView": creativeViews.append(trackingUrl)
            case "start": startEvents.append(trackingUrl)
            case "firstQuartile": firstQuartiles.append(trackingUrl)
            case "midpoint": midPoints.append(trackingUrl)
            case "thirdQuartile": thirdQuartiles.append(trackingUrl)
            case "complete": completes.append(trackingUrl)
            default: print("othter event \(event) \(trackingUrl)")
            }
            trackingUrl = ""
        }
        if currentElements.last == "ClickTracking" && !clickTrackingUrl.isEmpty {
            clickTrackingEvents.append(clickTrackingUrl.replacingOccurrences(of: "&;", with: "&"))
            clickTrackingUrl = ""
        }
        if currentElements.last == "Impression" && !impressionsUrl.isEmpty {
            impressions.append(impressionsUrl)
            impressionsUrl = ""
        }
        if currentElements.last == "Error" && !errorUrl.isEmpty {
            errors.append(errorUrl)
            errorUrl = ""
        }
        if currentElements.last == "MediaFile" && !mediaUrl.isEmpty {
            currentMedia?.url = mediaUrl
            mediaUrl = ""
            if let media = currentMedia {
                medias.append(media)
            }
        }
        event = nil
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if !data.isEmpty {
            if redirect == nil && currentElements.last == "VASTAdTagURI" {
                redirect = data
            }
            if currentElements.last == "Tracking" {
                trackingUrl += data
            }
            if currentElements.last == "ClickThrough"{
                if clickThrough != nil {
                    clickThrough! += data
                } else {
                    clickThrough = data
                }
            }
            if currentElements.last == "ClickTracking"{
                clickTrackingUrl += data
            }
            if currentElements.last == "Impression" {
                impressionsUrl += data
            }
            if currentElements.last == "Error" {
                errors.append(data)
            }
            if currentElements.last == "MediaFile"{
                currentMedia?.url = data
                if let media = currentMedia {
                    medias.append(media)
                }
            }

            print("_mark foundCharacters \(string)")
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        vastAd = VastAd(url: getUrl(medias: medias), type: type, redirect: redirect, errorEvents: errors,
                        impressions: impressions, clickThrough: clickThrough, creativeViewEvents: creativeViews,
                        startEvents: startEvents, firstQuartileEvents: firstQuartiles,
                        midPointEvents: midPoints, thirdQuartileEvents: thirdQuartiles,
                        completeEvents: completes, clickTrackingEvents: clickTrackingEvents,
                        media: medias)
    }
}
