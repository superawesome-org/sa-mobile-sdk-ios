//
//  VastParser.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 06/07/2020.
//

import SwiftyXMLParser

protocol VastParserType {
    func parse(_ data: Data) -> VastAd
}

class VastParser: NSObject, VastParserType {
    func parse(_ data: Data) -> VastAd {
        let vastAd = VastAd()
        let xml = XML.parse(data)
        var root: XML.Accessor
        
        if xml.VAST.Ad.InLine.error != nil {
            vastAd.type = .InLine
            root = xml.VAST.Ad.InLine
        } else if xml.VAST.Ad.Wrapper.error != nil {
            vastAd.type = .Wrapper
            root = xml.VAST.Ad.Wrapper
        } else {
            return vastAd
        }
        
        if let value = root.VASTAdTagURI.text {
            vastAd.redirect = value
        }
        
        if let value = root.Error.text {
            vastAd.events.append(VastEvent(event: "vast_error", url: value))
        }
        
        if let value = root.Impression.text {
            vastAd.events.append(VastEvent(event: "vast_impression", url: value))
        }
                          
        for linear in root.Creatives.Creative.Linear {
            
            linear.VideoClicks.ClickThrough.iterateValues().forEach { value in
                vastAd.events.append(VastEvent(event: "vast_click_through", url: value))
            }
            
            linear.VideoClicks.ClickTracking.iterateValues().forEach { value in
                vastAd.events.append(VastEvent(event: "vast_click_tracking", url: value))
            }
            
            for tracking in linear.TrackingEvents.Tracking {
                if let event = tracking.attributes["event"], let url = tracking.text {
                    vastAd.events.append(VastEvent(event: "vast_\(event)", url: url))
                }
            }
            
            for media in linear.MediaFiles.MediaFile {
                if let type = media.attributes["type"],
                    type.contains("mp4"),
                    let url = media.text,
                    let bitrate = media.attributes["bitrate"]?.toInt,
                    let width = media.attributes["width"]?.toInt,
                    let height = media.attributes["height"]?.toInt {
                    
                    let media = VastMedia(type: type, url: url, bitrate: bitrate, width: width, height: height)
                    vastAd.medias.append(media)
                }
            }
        }
        
        return vastAd
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
